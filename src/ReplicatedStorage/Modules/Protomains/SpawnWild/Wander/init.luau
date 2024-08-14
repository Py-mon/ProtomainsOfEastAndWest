local Wander = {}

local TweenService = game:GetService("TweenService")
local RayCast2DSurface = require(game:GetService("ReplicatedStorage").Modules.Utils.RayCast2DSurface)
local getRandom2DCoordinatesOnPart = require(script.GetRandom2DCoordinatesOnPart)

local DEGREES_PER_SECOND = 50
local STUDS_PER_SECOND = 5

function Wander.getRandomEncounterPosition(protomainModel, encounterArea)
	return getRandom2DCoordinatesOnPart(encounterArea) + Vector3.new(0, protomainModel.Size.Y / 2, 0)
end

function Wander.wander(model: Part, encounterArea, encounteredEvent: BindableEvent)
	local function rotate(targetPosition)
		local endRotation = CFrame.lookAt(model.Position, targetPosition, encounterArea.CFrame.UpVector)

		-- Help from discord @goooberj
		local angle = math.deg(math.acos(model.CFrame.LookVector:Dot(endRotation.LookVector)))

		local tweenInfo = TweenInfo.new(
			--1,
			angle / DEGREES_PER_SECOND,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			1
		)

		return TweenService:Create(model, tweenInfo, { CFrame = endRotation })
	end

	local function move(targetPosition)
		local distanceToTargetPosition =
			math.sqrt((model.Position.X - targetPosition.X) ^ 2 + (model.Position.Z - targetPosition.Z) ^ 2)
		local distanceToTargetPosition = ((model.Position - targetPosition) * (Vector3.new(1, 0, 1))).Magnitude

		local tweenInfo = TweenInfo.new(
			distanceToTargetPosition / STUDS_PER_SECOND,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		)

		local rot = model.CFrame - model.CFrame.Position
		return TweenService:Create(model, tweenInfo, { CFrame = CFrame.new(targetPosition) * rot })
	end

	local activeTween
	local target

	local isRotateTurn = true
	local isRunning = true

	encounteredEvent.Event:Once(function()
		isRunning = false
		activeTween:Cancel()
	end)

    --! system to detect wrong movement not ideal
    -- don't think it is needed

	local function rayCast(oldTarget, target)
		local centerZ = (oldTarget.Z + target.Z) / 2
		local centerX = (oldTarget.X + target.X) / 2

		local start = Vector2.new(centerX, centerZ)
		local ray = RayCast2DSurface.new(encounterArea)

		local result = RayCast2DSurface.partIsAbove(ray, start)
		print(result)
		return result -- true if someting
	end

	task.spawn(function()
		while isRunning do
			if isRotateTurn then
				if target then
					local oldTarget = target
					local ray
					repeat
						target = Wander.getRandomEncounterPosition(model, encounterArea)
						ray = rayCast(oldTarget, target)
					until not ray
				else
					target = Wander.getRandomEncounterPosition(model, encounterArea)
				end

				activeTween = rotate(target)
			else
				activeTween = move(target)
			end

			isRotateTurn = not isRotateTurn

			activeTween:Play()
			activeTween.Completed:Wait()
		end
	end)
end

return Wander
