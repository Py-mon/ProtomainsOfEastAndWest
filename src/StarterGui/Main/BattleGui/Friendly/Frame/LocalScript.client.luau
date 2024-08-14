local GUI = script.Parent

GUI.Position = UDim2.new(-0.5, 0, 0.671, 0)

game.Players.LocalPlayer.Character:WaitForChild("IsBattle").Changed:Connect(function()
	if game.Players.LocalPlayer.Character.IsBattle == false then
		return
	end
	wait(1.5)
	GUI:TweenPosition(UDim2.new(0.06, 0, 0.671, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1)
end)
