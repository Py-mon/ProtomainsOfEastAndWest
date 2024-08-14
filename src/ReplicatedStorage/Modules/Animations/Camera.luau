local Camera = {}

local TweenService = game:GetService("TweenService")

local camera = workspace.CurrentCamera

local player = game.Players.LocalPlayer
local character = player.Character
local playerHead = character:WaitForChild("Head")

local Humanoid = character:WaitForChild("Humanoid")
local gui = player.PlayerGui
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")


function Camera.lookAt(part, distance, seconds, offset)
	camera.CameraType = Enum.CameraType.Scriptable

	local newCameraCFrame = CFrame.lookAt(
		playerHead.Position - playerHead.CFrame.LookVector * distance + (offset or Vector3.new(0,0,0)),
		part.Position
	)

	TweenService:Create(
		camera,
		TweenInfo.new(seconds or 1),
		{
			CFrame = newCameraCFrame
		}
	):Play()
	
	return newCameraCFrame
end

return Camera