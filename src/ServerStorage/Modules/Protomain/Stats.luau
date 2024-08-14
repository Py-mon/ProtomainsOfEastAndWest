local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)

local Stats_ = {}

Stats_.numberOfStats = 7

--[[
    Create a dictionary of all the Stats with a set value.
]]
function Stats_._createStats(value: number): Typing.Stats_
	return {
		health = value,
		energy = value,
		speed = value,
		rangedAttack = value,
		rangedDefense = value,
		meleeAttack = value,
		meleeDefense = value,
	} :: Typing.Stats_
end

--[[
    Create a dictionary of all the Stats with values of 0.
]]
function Stats_.createStats0(): Typing.Stats_
	return Stats_._createStats(0)
end

--[[
    Create a dictionary of all the Stats with values of 0 to be added.
]]
function Stats_.createAddedStats(): Typing.Stats_
	return Stats_.createStats0()
end

--[[
    Create a dictionary of all the Stats with values of 1 to be multipled.
]]
function Stats_.createMultipliedStats(): Typing.Stats_
	return Stats_._createStats(1)
end

return Stats_
