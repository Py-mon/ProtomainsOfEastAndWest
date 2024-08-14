local player = game.Players.LocalPlayer
local character = player.Character
local camera = game.Workspace.CurrentCamera
local playerHead = character:WaitForChild("Head")
local Humanoid = character:WaitForChild("Humanoid")
local gui = player.PlayerGui
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local controls = require(player.PlayerScripts.PlayerModule):GetControls()

local Modules = game:GetService("ReplicatedStorage").Modules

local FadeScreen = require(Modules.Gui.FadeScreen)

local TweenService = game:GetService("TweenService")

function run(protomainModel)
	local function faceAwayFromProtomain()
		local newOrientation = CFrame.lookAt(humanoidRootPart.Position, protomainModel.Position)
			* CFrame.Angles(0, -(math.pi * 1.2), 0)

		local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {
			CFrame = newOrientation,
		})
		tween:Play()
		tween.Completed:Wait()

		return newOrientation
	end

	controls:Disable()

	faceAwayFromProtomain()

	print("Do you want to run away from the battle?")

	task.wait(1)

	for _, wall in protomainModel.Wall:GetChildren() do
		wall.CanCollide = false
	end

	Humanoid.WalkSpeed = 7
	character.Humanoid:MoveTo(humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 7)
	task.wait(0.1)
	FadeScreen.fadeIn()
	Humanoid.WalkSpeed = 16
	FadeScreen.fadeOut()
	controls:Enable()
	camera.CameraType = Enum.CameraType.Custom
end
return run
