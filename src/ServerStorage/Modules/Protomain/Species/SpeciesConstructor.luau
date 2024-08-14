local Species = {}

local Modules = game:GetService("ReplicatedStorage").Modules

local Typing = require(Modules.Protomains.Typing)


function Species.new(array: any)
	--[[
		Create a new Species.
	]]
	local self = array :: Typing.Species

	self.maleChance = array.maleChance or 1/2
	
	local lastStageName = self.evolutions[#self.evolutions].name
	self.name = lastStageName
	
	return self
end

return Species