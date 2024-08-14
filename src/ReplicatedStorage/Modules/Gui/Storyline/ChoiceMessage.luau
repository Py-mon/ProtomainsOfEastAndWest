local TypewriteMessage = require(script.Parent.TypewriteMessage)

local gui = game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Input

local TweenService = game:GetService("TweenService")
function choiceMessage(text: string, speaker: string, choices: { string })
	gui.Visible = false

	TypewriteMessage.typewrite(text, speaker)

	gui.Visible = true
	gui.ImageLabel.Position = gui.Yes.Position
		- UDim2.new(gui.Yes.Size.X.Scale / 2 + gui.ImageLabel.Size.X.Scale / 2 + 0.1, 0, 0, 0)

	gui.Yes.MouseEnter:Connect(function()
		TweenService:Create(
			gui.ImageLabel,
			TweenInfo.new(1),
			{
				Position = gui.Yes.Position
					- UDim2.new(gui.Yes.Size.X.Scale / 2 + gui.ImageLabel.Size.X.Scale / 2 + 0.1, 0, 0, 0),
			}
		):Play()
	end)
	gui.No.MouseEnter:Connect(function()
		TweenService:Create(
			gui.ImageLabel,
			TweenInfo.new(1),
			{ Position = gui.No.Position
				- UDim2.new(gui.No.Size.X.Scale / 2 + gui.ImageLabel.Size.X.Scale / 2 + 0.1, 0, 0, 0) }
		):Play()
	end)

	local result

	gui.No.MouseButton1Click:Once(function()
		gui.Visible = false

		result = false
	end)
	gui.Yes.MouseButton1Click:Once(function()
		gui.Visible = false

		result = true
	end)

	while result == nil do
		task.wait()
	end

	return result
end

-- TODO

return choiceMessage
