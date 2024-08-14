local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)

local Stage = {}

function Stage.new(array)
	local self = array :: Typing.Stage

	self.chanceAbilities = self.chanceAbilities or {}
	self.setAbilities = self.setAbilities or {}
	self.moves = self.moves or {}
	self.types = self.types or {}

	return self
end

--[[
    Get the sum of all the Stage's Stats.
]]
function Stage.getStatTotal(evolution: Typing.Stage)
	local statTotal = 0
	for _, statValue in pairs(evolution.baseStats) do
		statTotal += statValue
	end
	return statTotal
end

return Stage
