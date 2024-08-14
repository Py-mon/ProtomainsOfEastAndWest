local FadeScreen = {}

local TweenService = game:GetService("TweenService")

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local blackScreen = playerGui:WaitForChild("BlackScreen") :: GuiMain

local FADE_TIME = 1

function FadeScreen.fadeIn(block: boolean?)
	block = block or true

	blackScreen.Enabled = true
	blackScreen.BlackScreen.BackgroundTransparency = 1

	local fadeIn =
		TweenService:Create(blackScreen.BlackScreen, TweenInfo.new(FADE_TIME), { BackgroundTransparency = 0 })
	fadeIn:Play()

	if block then
		fadeIn.Completed:Wait()
	end
end

function FadeScreen.fadeOut(block: boolean?)
	block = block or true

	local fadeOut =
		TweenService:Create(blackScreen.BlackScreen, TweenInfo.new(FADE_TIME), { BackgroundTransparency = 1 })
	fadeOut:Play()

	if block then
		fadeOut.Completed:Wait()
	end

	blackScreen.Enabled = false
end

return FadeScreen