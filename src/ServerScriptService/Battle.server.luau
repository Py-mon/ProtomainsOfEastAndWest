local Replicated = game:GetService("ReplicatedStorage")
local folder = game.Workspace.Creatures
local check = false
local Battle = Replicated.Events.GUIBattleStart
local plr = game.Players.PlayerAdded:Wait()

local function Cooldown(time_)
	check = true
	wait(time_)
	check = false
end

for i, p in pairs(folder:GetChildren()) do
	p.Touched:Connect(function(p)
		if p.Parent and p.Parent:FindFirstChild("Humanoid") and check == false then
			p.CanTouch = false
			local char = p.Parent

			Battle:FireClient(plr)
			wait()
			char:MoveTo(p.Position + Vector3.new(-10, 0, -10))
			p.CFrame = p.CFrame:ToWorldSpace(CFrame.Angles(0, math.rad(-45), 0))
			wait(0.1)
			char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, p.Position)
			Cooldown(2.5)
			p.CanTouch = true
		end
	end)
end
