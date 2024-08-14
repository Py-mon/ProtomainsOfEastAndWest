
wait(5)
local UIS = game:GetService("UserInputService")
local Replicated = game:GetService("ReplicatedStorage")
local module = require(Replicated.ProtoInfo)
local maxHealth = module.Floracri.Health
local currentHealth = Replicated.Values.CurrentHealth

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.E then
		if currentHealth.Value >= 0 then
			currentHealth.Value -= 10
		end
	end
end)
 UIS = game:GetService("UserInputService")
local Replicated = game:GetService("ReplicatedStorage")
local module = require(Replicated.ProtoInfo)
local maxHealth = module.Floracri.Health
local currentHealth = Replicated.Values.CurrentHealth

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.E then
		if currentHealth.Value >= 0 then
			currentHealth.Value -= 10
		end
	end
end)
