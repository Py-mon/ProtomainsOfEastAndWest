local Encounter = require(script.Encounter)
local Wander = require(script.Wander)

local CatchProtomain = game:GetService("ReplicatedStorage").Events.CatchProtomain


function spawnWildProtomain(
	protomain: Typing.Protomain,
	encounterArea: Part
)
local protomainModel = protomain.evolution.model:Clone() :: Part
	protomainModel.Parent = encounterArea:WaitForChild("Creatures")
	
	local encounterBox
	
	local function addHitBox()
		encounterBox = Instance.new("Part")
		print(protomainModel)
		encounterBox.Size = protomainModel.Size + Vector3.new(2, 2, 2)
		encounterBox.Transparency = 1
		encounterBox.Anchored = false
		encounterBox.CanCollide = false
		encounterBox.Parent = protomainModel
		
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = protomainModel
		weld.Part1 = encounterBox
		weld.Parent = protomainModel
	end

	local function spawnProtomain()
		protomainModel.CFrame = CFrame.new(
			Wander.getRandomEncounterPosition(protomainModel, encounterArea)
		) * encounterArea.CFrame.Rotation
	end

	addHitBox()
	
	spawnProtomain()
	
	local encountered = Instance.new("BindableEvent")

	Wander.wander(
		protomainModel,
		encounterArea,
		encountered
	)
	
	local event1 do
		event1 = encounterBox.Touched:Connect(function(touched)
			if not touched.Parent:FindFirstChildOfClass("Humanoid") then
				return
			end
			event1:Disconnect()
			CatchProtomain:InvokeServer(protomain)
			encountered:Fire()
			Encounter(protomainModel, encounterBox)
		end)
	end

end

return spawnWildProtomain