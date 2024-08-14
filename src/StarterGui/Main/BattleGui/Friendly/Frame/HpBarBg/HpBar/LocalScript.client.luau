--!strict

wait(3)
local Replicated = game:GetService("ReplicatedStorage")
local currentHealth = Replicated.Values.CurrentHealth
local module = require(Replicated.ProtoInfo)
local MaxHealth = module.Floracri.Health
local char = game.Players.LocalPlayer.Character
local healthBar = script.Parent
local TS = game:GetService("TweenService")

currentHealth.Changed:Connect(function()
	if currentHealth.Value >= 0 and currentHealth.Value <= MaxHealth then
		healthBar:TweenSize(
			UDim2.new(currentHealth.Value /MaxHealth, 0, 1, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quint,
			0.5
		)
		--healthBar.Size = UDim2.new(char.CurrentHealth.Value /char.MaxHealth.Value, 0, 1, 0)
	end
end)icated = game:GetService("ReplicatedStorage")
local currentHealth = Replicated.Values.CurrentHealth
local module = require(Replicated.ProtoInfo)
local MaxHealth = module.Floracri.Health
local char = game.Players.LocalPlayer.Character
local healthBar = script.Parent
local TS = game:GetService("TweenService")

currentHealth.Changed:Connect(function()
	if currentHealth.Value >= 0 and currentHealth.Value <= MaxHealth then
		healthBar:TweenSize(
			UDim2.new(currentHealth.Value /MaxHealth, 0, 1, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quint,
			0.5
		)
		--healthBar.Size = UDim2.new(char.CurrentHealth.Value /char.MaxHealth.Value, 0, 1, 0)
	end
end)