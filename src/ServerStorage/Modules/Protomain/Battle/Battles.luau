local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreateBattleEvent = require(script.Parent.CreateBattleEvent)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local Utils = require(ReplicatedStorage.Modules.Utils.Utils)

local Battle = {}

Battle.events = {}

-- note: allies include the protomain itself
--[[
    Start a new battle.
]]
function Battle.start(allies: { Typing.Protomain }, opponents: { Typing.Protomain })
	local self = {} :: Typing.Battle

	self.allies = allies
	self.opponents = opponents
	self.allProtomains = Utils.combineArrays(self.allies, self.opponents)

	-- for _, ally in allies do
	-- 	ally.battle = self
	-- end

	-- for _, opponent in opponents do
	-- 	opponent.battle = table.clone(self)
	-- end

	self.eventsRunning = {}

	for _, protomain in self.allProtomains do
		for _, ability in protomain.abilities do
			local events = ability.battleStart(protomain)
			if type(events) == "table" then
				for _, event in events do
					table.insert(self.eventsRunning, event)
				end
			else
				table.insert(self.eventsRunning, ability.battleStart(protomain))
			end
		end
	end

	for _, protomain in self.allProtomains do
		protomain._energyUsed = 0
	end

	return self
end

function Battle.stop(battle: Typing.Battle)
	for _, event in battle.eventsRunning do
		event.disconnect()
	end
end

local function recalculateAllProtomains(battle: Typing.Battle)
	battle.allProtomains = Utils.combineArrays(battle.allies, battle.opponents)
end

Battle.events.switch, Battle.switch = CreateBattleEvent(
	function(battle: Typing.Battle, switchOut: Typing.Protomain, switchIn: Typing.Protomain) -- may need to divide this function to do after switchOut
		local index = table.find(battle.allies, switchOut)

		if index then
			table.remove(battle.allies, index)
			table.insert(battle.allies, switchIn)
		else
			index = table.find(battle.opponents, switchOut)
			if index then
				table.remove(battle.opponents, index)
				table.insert(battle.opponents, switchIn)
			else
				error("switchOut not found")
			end
		end

		recalculateAllProtomains(battle)
	end
)

return Battle
