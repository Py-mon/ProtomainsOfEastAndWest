local BLACK_BARS_SLIDE_ANIMATION_SECONDS = 1
local BUTTON_SLIDE_ANIMATION_SECONDS = 1

local Modules = game:GetService("ReplicatedStorage").Modules

local Typing = require(Modules.Protomains.Typing)
local FadeScreen = require(Modules.Gui.FadeScreen)
local Camera = require(Modules.Animations.Camera)
local Video = require(Modules.Video)
local EncounterExclamationPointVideo = require(Modules.Video.EncounterExclamationPoint).new()

local Animations = require(script.Animations)
local Run = require(script.Run)

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = game.Players.LocalPlayer
local character = player.Character
local camera = game.Workspace.CurrentCamera
local playerHead = character:WaitForChild("Head")
local Humanoid = character:WaitForChild("Humanoid")
local gui = player.PlayerGui
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local controls = require(player.PlayerScripts.PlayerModule):GetControls()

local BattleGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("BattleGui")

local attackButton = BattleGui.Buttons.Attack
local switchButton = BattleGui.Buttons.Switch
local inventoryButton = BattleGui.Buttons.Inventory
local runButton = BattleGui.Buttons.Run

local attackButtonPosition = attackButton.Position
local switchButtonPosition = switchButton.Position
local inventoryButtonPosition = inventoryButton.Position
local runButtonPosition = runButton.Position

function encounter(protomainModel)
	local function exclamationPoint()
		gui.Main.EncounterGui.Exclamation.Adornee = protomainModel
		gui.Main.EncounterGui.Exclamation.Enabled = true

		Video.play(EncounterExclamationPointVideo, 36, gui.Main.EncounterGui.Exclamation.VideoDisplay)
	end

	local function turnProtomainToCamera(newCameraCFrame)
		TweenService:Create(protomainModel, TweenInfo.new(1), {
			CFrame = CFrame.lookAt(protomainModel.Position, newCameraCFrame.Position),
		}):Play()
	end

	local BOUNDARY_DISTANCE = 25

	local function createWallBoundaries()
		local HEIGHT = 20

		local folder = Instance.new("Folder")
		folder.Name = "Wall"
		folder.Parent = protomainModel

		local wall1 = Instance.new("Part")
		wall1.Size = Vector3.new(BOUNDARY_DISTANCE * 2, HEIGHT, 0.1)
		wall1.Transparency = 1
		wall1.Position = protomainModel.Position - Vector3.new(0, 0, BOUNDARY_DISTANCE)
		wall1.Anchored = true
		wall1.Parent = folder

		local wall2 = wall1:Clone()
		wall2.Size = Vector3.new(BOUNDARY_DISTANCE * 2, HEIGHT, 0.1)
		wall2.Position = protomainModel.Position + Vector3.new(0, 0, BOUNDARY_DISTANCE)
		wall2.Parent = folder

		local wall3 = wall1:Clone()
		wall3.Size = Vector3.new(0.1, HEIGHT, BOUNDARY_DISTANCE * 2)
		wall3.Position = protomainModel.Position + Vector3.new(BOUNDARY_DISTANCE, 0, 0)
		wall3.Parent = folder

		local wall4 = wall1:Clone()
		wall4.Size = Vector3.new(0.1, HEIGHT, BOUNDARY_DISTANCE * 2)
		wall4.Position = protomainModel.Position - Vector3.new(BOUNDARY_DISTANCE, 0, 0)
		wall4.Parent = folder
	end

	local function faceProtomain()
		humanoidRootPart.CFrame = CFrame.lookAt(
			humanoidRootPart.Position,
			Vector3.new(protomainModel.Position.X, humanoidRootPart.Position.Y, protomainModel.Position.Z)
		)
	end

	local function lookAtProtomain()
		local newCameraCFrame = CFrame.lookAt(
			humanoidRootPart.Position
				- humanoidRootPart.CFrame.LookVector * 5
				+ Vector3.new(0, 2, 0)
				+ humanoidRootPart.CFrame.RightVector * 3,
			protomainModel.Position
		)

		local tween = TweenService:Create(camera, TweenInfo.new(0.1), {
			CFrame = newCameraCFrame,
		})
		tween:Play()
		tween.Completed:Wait()
	end

	BattleGui.Enabled = true

	exclamationPoint()

	local newCameraCFrame = Camera.lookAt(protomainModel, 8)

	createWallBoundaries()

	local orginalPlayerPos = humanoidRootPart.Position

	character:MoveTo(protomainModel.Position - (humanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 0, -15)))

	task.wait(0.5)

	turnProtomainToCamera(newCameraCFrame)

	task.wait(1)

	FadeScreen.fadeIn()

	character:MoveTo(orginalPlayerPos - humanoidRootPart.CFrame.LookVector * 9 + Vector3.new(0, 0, 5))
	faceProtomain()

	camera.CFrame =
		CFrame.lookAt(humanoidRootPart.Position - humanoidRootPart.CFrame.LookVector * 4, protomainModel.Position)
	FadeScreen.fadeOut()

	task.wait(1)

	Camera.lookAt(protomainModel, 16)

	local followPlayer
	do
		followPlayer = RunService.RenderStepped:Connect(function()
			faceProtomain()

			lookAtProtomain()

			Humanoid.JumpHeight = 0

			local distanceFromProtomain = (humanoidRootPart.Position - protomainModel.Position).Magnitude
			if distanceFromProtomain > BOUNDARY_DISTANCE then
				if followPlayer == nil then
					return
				end

				followPlayer:Disconnect()
				followPlayer = nil

				Run(protomainModel)
			end
		end)
	end

	task.wait(0.3)

	Animations.blackBars()

	task.wait(0.75)

	Animations.slideButtons()
end

return encounter
