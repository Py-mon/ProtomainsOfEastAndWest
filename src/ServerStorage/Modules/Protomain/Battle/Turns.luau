local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Move = require(ServerStorage.Modules.Protomain.Species.Moves.Move)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local CreateBattleEvent = require(script.Parent.CreateBattleEvent)
local Protomain = require(script.Parent.Parent)

local Turns = {}

export type Turns = { allTurns: { Typing.Protomain }, turnQueue: { Typing.Protomain }, battle: Typing.Battle }

function Turns.new(battle: Typing.Battle)
	local self = {} :: Turns

	self.battle = battle
	self.turnQueue = table.clone(battle.allProtomains)

	return self
end

-- before and after turns?

function Turns.getNextTurn(turns: Turns)
	--[[
		Get the next Protomain's turn.
	]]

	local protomainsWithMoves = {}
	for _, protomain in turns.turnQueue do
		if protomain.move then
			table.insert(protomainsWithMoves, protomain)
		end
	end

	table.sort(protomainsWithMoves, function(protomain1: Typing.Protomain, protomain2: Typing.Protomain)
		local speed1, speed2 = Protomain.get.stat(protomain1, "speed"), Protomain.get.stat(protomain2, "speed")

		local priority1, priority2 = protomain1.move.priority, protomain2.move.priority

		if speed1 == speed2 and priority1 == priority2 then
			return math.random() < 0.5
		end

		local priority = protomain1.move.priority > protomain2.move.priority
		local speed = Protomain.get.stat(protomain1, "speed") > Protomain.get.stat(protomain2, "speed")
		return priority or speed
	end)
	local nextTurn = protomainsWithMoves[1]
	table.remove(turns.turnQueue, table.find(turns.turnQueue, nextTurn))
	return nextTurn
end

local function playTurns(turns: Turns)
	for _, protomain in turns.battle.allProtomains do
		protomain.statusEffectTurnNumber += 1

		if protomain.statusEffect and protomain.statusEffect.endCondition(protomain) then
			protomain.statusEffect.endMessage()
			protomain.statusEffect = nil
		end
	end

	while true do
		local protomain = Turns.getNextTurn(turns)
		if not protomain then
			break
		end
		Move.use(protomain)
	end
end

Turns.events = {}
Turns.events.playTurns, Turns.playTurns = CreateBattleEvent(playTurns)

return Turns
