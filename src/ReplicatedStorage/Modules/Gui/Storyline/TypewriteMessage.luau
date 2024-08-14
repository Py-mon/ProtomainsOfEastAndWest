local Text = {}

local TYPEWRITE_SPEED = 0.03

local WAIT_TABLE = {
	["."] = 0.5,
	[","] = 0.25,
}

local firstLine = game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox.FirstLine
local secondLine = game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox.SecondLine

local MAX_CLICKS = 2

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

-- make module return a function
function Text.typewrite(text: string, speaker: string)
	game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Enabled = true
	game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Speaker.Text = speaker

	local clicked = false

	local detectClicks = game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox.ImageButton.MouseButton1Click:Connect(
		function()
			clicked = true
		end
	)

	local PADDING = 200

	local words = string.split(text, " ")

	local startIndex = 1
	local currentWords = ""
	local text = text

	local function getNextLine()
		for i = 1, #words do
			if
				TextService:GetTextSize(
						currentWords,
						firstLine.TextSize,
						firstLine.Font,
						firstLine.AbsoluteSize + Vector2.new(999, 999)
					).X
					+ PADDING
				> firstLine.AbsoluteSize.X
			then
				startIndex = i
				local result = currentWords
				currentWords = table.concat(words, " ", startIndex, i)
				return result
			end
			currentWords = table.concat(words, " ", startIndex, i)
		end
		return { done = true, words = currentWords }
	end

	local function addCharacter(line, fullLine, i)
		line.Text = string.sub(fullLine, 1, i)

		local addedCharacter = string.sub(text, i, i)
		local waitTime = WAIT_TABLE[addedCharacter]

		if clicked then
			return
		elseif waitTime then
			task.wait(waitTime)
		else
			game:GetService("RunService").Heartbeat:Wait()
		end
	end

	-- First Line
	local line1 = getNextLine()
	local lineIndex = 1
	for i = 1, #line1 do
		addCharacter(firstLine, line1, i)
	end
	clicked = false

	-- clean up with generator (and remove lineResult)
	while true do
		lineIndex += 1
		local lineResult = getNextLine()
		local line
		if lineResult.done == true then
			line = lineResult.words
		else
			line = lineResult
		end

		for i = 1, #line do
			addCharacter(secondLine, line, i)
		end

		if lineIndex % 2 == 0 then
			if clicked then
				task.wait(0.5)
			end

			game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox.Arrow.Visible = true
			game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox.Arrow.MouseButton1Click:Wait()
			game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox.Arrow.Visible = false
		end

		if lineResult.done == true then
			break
		end

		-- Shift lines down
		local below = firstLine.Position - UDim2.new(0, 0, secondLine.Size.Y.Scale, 0)
		local above = secondLine.Position + UDim2.new(0, 0, secondLine.Size.Y.Scale, 0)

		local newSecondLine = secondLine:Clone()
		newSecondLine.Text = ""
		newSecondLine.Position = above
		newSecondLine.Parent = game.Players.LocalPlayer.PlayerGui.TypewriteMessage.Textbox

		local TIME = 1

		local moveNewLineIn =
			TweenService:Create(newSecondLine, TweenInfo.new(TIME), { Position = secondLine.Position })

		local moveSecondLineToFirst =
			TweenService:Create(secondLine, TweenInfo.new(TIME), { Position = firstLine.Position })

		local movefirstLineAway = TweenService:Create(firstLine, TweenInfo.new(TIME), { Position = below })

		moveNewLineIn:Play()
		moveSecondLineToFirst:Play()
		movefirstLineAway:Play()
		task.wait(0.05)

		firstLine = secondLine
		secondLine = newSecondLine

		clicked = false
	end

	detectClicks:Disconnect()
end

return Text
