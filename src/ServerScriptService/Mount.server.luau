game.Players.PlayerAdded:Connect(function(player)
	local character = player.Character or player.CharacterAdded:Wait()

	wait(3)

	local animateScript

	for i, v in pairs(character:GetDescendants()) do -- loop through everything in the character
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.Transparency = 1 -- make it invisible
		elseif v:IsA("LocalScript") and v.Name == "Animate" then
			animateScript = v
			v.Parent = nil
		end
	end

	for i, v in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end

	local part = Instance.new("Part")
	part.Size = Vector3.new(4, 5, 4)
	part.FrontSurface = Enum.SurfaceType.Studs
	part.Parent = character
	part.Velocity = Vector3.new(0, 0, 0)

	local Weld = Instance.new("Weld", part)
	Weld.Name = "Weld"
	Weld.Part0 = part
	Weld.Part1 = character.Head
	Weld.C0 = CFrame.new(0, 2, 0)

	task.wait(5)
	part.Velocity = Vector3.new(0, 0, 0)

	part:Destroy()

	for i, v in pairs(character:GetDescendants()) do
		if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then
			v.Transparency = 0 -- make it invisible
		end
	end
	animateScript.Parent = character
end)
