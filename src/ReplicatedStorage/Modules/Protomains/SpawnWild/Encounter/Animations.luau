local Animations = {}


local BLACK_BARS_SLIDE_ANIMATION_SECONDS = 1
local BUTTON_SLIDE_ANIMATION_SECONDS = 1



local BattleGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("BattleGui")

local attackButton = BattleGui.Buttons.Attack
local switchButton = BattleGui.Buttons.Switch
local inventoryButton = BattleGui.Buttons.Inventory
local runButton = BattleGui.Buttons.Run

local attackButtonPosition = attackButton.Position
local switchButtonPosition = switchButton.Position
local inventoryButtonPosition = inventoryButton.Position
local runButtonPosition = runButton.Position

-- Send off screen
BattleGui.TopFrame.Position = UDim2.new(0, 0, -1, 0)
BattleGui.BottomFrame.Position = UDim2.new(0, 0, 2, 0)

-- Send off screen
attackButton.Position = UDim2.new(2, 0, attackButton.Position.Y.Scale, 0)
inventoryButton.Position = UDim2.new(2, 0, inventoryButton.Position.Y.Scale, 0)
runButton.Position = UDim2.new(2, 0, inventoryButton.Position.Y.Scale, 0)
switchButton.Position = UDim2.new(2, 0, inventoryButton.Position.Y.Scale, 0)

function Animations.blackBars()
	BattleGui.TopFrame:TweenPosition(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BLACK_BARS_SLIDE_ANIMATION_SECONDS,
		true
	)
	BattleGui.BottomFrame:TweenPosition(
		UDim2.new(0, 0, 1, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BLACK_BARS_SLIDE_ANIMATION_SECONDS,
		true
	)
end

function Animations.slideButtons()
	attackButton:TweenPosition(
		attackButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
	inventoryButton:TweenPosition(
		inventoryButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
	runButton:TweenPosition(
		runButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
	switchButton:TweenPosition(
		switchButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
end


function Animations.slideButtonsOut()
	attackButton:TweenPosition(
		attackButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
	inventoryButton:TweenPosition(
		inventoryButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
	runButton:TweenPosition(
		runButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
	switchButton:TweenPosition(
		switchButtonPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		BUTTON_SLIDE_ANIMATION_SECONDS,
		true
	)
end

return Animations
