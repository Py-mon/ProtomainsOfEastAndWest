local ServerStorage = game:GetService("ServerStorage")
local ReplicatedModules = game:GetService("ReplicatedStorage").Modules

local CreateBattleEvent = require(ServerStorage.Modules.Protomain.Battle.CreateBattleEvent)
local Protomain = require(script.Parent.Parent.Parent)
local Types = require(ServerStorage.Modules.Protomain.Battle.Types)
local Typing = require(ReplicatedModules.Protomains.Typing)
local Utils = require(ReplicatedModules.Utils.Utils)

local Move = {}

function Move.new(array)
	local self = array :: Typing.Move

	self.accuracy = self.accuracy or 1
	self.priority = self.priority or 0

	self.physicalContact = self.physicalContact or false

	self.target = self.target or "opponent"

	self.neverMissPriority = self.neverMissPriority or 0

	self.blockPriority = self.blockPriority or 0

	return self
end

local CRITICAL = {
	CHANCE = 0.05,
	POWER = 1.50,
}

local MOVE_DAMAGE = {
	LEVEL_MULT = 2 / 5,
	LEVEL_MINIMUM = 2,
	DIVIDER = 30,
}

local EVASION_CLIMB_RATE = 0.10

Move.events = {}

local calculateAttackTyping
Move.events.calculateAttackTyping, calculateAttackTyping = CreateBattleEvent(
	function(attacker: Typing.Protomain, defender: Typing.Protomain)
		return Types.getMultiplierBetween({ attacker.move.type_ }, defender.evolution.types)
	end
)

local calculateAttackPower
Move.events.calculateAttackPower, calculateAttackPower = CreateBattleEvent(function(protomain: Typing.Protomain)
	local attack
	local defense
	if protomain.move.category == "melee" then
		attack = Protomain.get.stat(protomain, "meleeAttack")
		defense = Protomain.get.stat(protomain.target, "meleeDefense")
	elseif protomain.move.category == "ranged" then
		attack = Protomain.get.stat(protomain, "rangedAttack")
		defense = Protomain.get.stat(protomain.target, "rangedDefense")
	else
		error("move category is bad")
	end
	return attack / defense
end)

local useMoveFunction
Move.events.useMoveFunction, useMoveFunction = CreateBattleEvent(function(protomain: Typing.Protomain)
	--if protomain.nextMoveFunc then
	--	protomain.moveTurnNumber += 1
	--	protomain.nextMoveFunc = nil
	--	protomain.nextMoveFunc(protomain, protomain.moveTurnNumber)
	--else
	--	protomain.moveTurnNumber = 1
	--	protomain.move.func(protomain)
	--end

	protomain.move.func(protomain)
end)

local calculateCriticalPower
Move.events.calculateCriticalPower, calculateCriticalPower = CreateBattleEvent(function(criticalChance: number)
	if math.random() < (criticalChance or CRITICAL.CHANCE) then
		return CRITICAL.POWER
	end
	return 1
end)

local calculateStab
Move.events.calculateStab, calculateStab = CreateBattleEvent(function(attacker: Typing.Protomain)
	if Utils.isIn(attacker.move.type_, attacker.evolution.types) then
		return 1 + 1 / (#attacker.evolution.types * 2) -- 1 type: 1 + 1/(1*2) = 1.5, 2 types: 1.25
	else
		return 1
	end
end)

local function displayEffectiveness(typing, attacker, target)
	if typing == 2 then
		print(`It is super effective against {target.evolution.name}.`)
	elseif typing == 4 then
		print(`It is super duper effective against {target.evolution.name}.`)
	elseif typing == 1 / 2 then
		print(`It isn't very effective against {target.evolution.name}.`)
	elseif typing == 1 / 4 then
		print(`It is very ineffective against {target.evolution.name}.`)
	elseif typing == 0 then
		print(`{target.evolution.name} is immune to {attacker.move.type_.name} type attacks!`)
	end
end

local calculateMoveDamage
Move.events.calculateMoveDamage, calculateMoveDamage = CreateBattleEvent(
	function(attacker: Typing.Protomain, target: Typing.Protomain, damageMult: number?, criticalChance: number?)
		local typing = calculateAttackTyping(attacker, target)
		displayEffectiveness(typing, attacker, target)

		local criticalPower = calculateCriticalPower(criticalChance)
		if criticalPower > 1 then
			print("It is a critical hit!")
		end

		local stab = calculateStab(attacker)

		local mult = damageMult or 1
		local totalDamage = (
			(
				calculateAttackPower(attacker)
				* attacker.move.basePower
				* typing
				* (MOVE_DAMAGE.LEVEL_MULT * attacker.level + MOVE_DAMAGE.LEVEL_MINIMUM)
				* mult
				* criticalPower
				* stab
			) / 30
		)
		return totalDamage
	end
)

Move.basicFuncs = {}

Move.events.dealDamagingMove, Move.basicFuncs.dealDamagingMove = CreateBattleEvent(
	function(protomain: Typing.Protomain, target: Typing.Protomain, mult: number?)
		Protomain.takeDamage(target, calculateMoveDamage(protomain, target) * Utils.oneIfNil(mult))
	end
)

function Move.use(protomain: Typing.Protomain): string
	-- TODO add single to move.target
	if protomain.move.target == "ally" or protomain.move.target == "opponent" then
		print(`{protomain.evolution.name} is using {protomain.move.name} on {protomain.target.evolution.name}.`)
	else
		print(`{protomain.evolution.name} is using {protomain.move.name}.`)
	end

	Protomain.useEnergy(protomain, protomain.move.energyCost)

	local function doesEvade(target: Typing.Protomain) -- the attack
		if target.move then
			if protomain.move.neverMissPriority > target.move.blockPriority then
				print(`{protomain.evolution.name}'s move never misses.`)
				return false
			elseif protomain.move.neverMissPriority < target.move.blockPriority then
				print(`{target.evolution.name} blocked the move.`)
				return true
			end -- maybe want 50% to hit or block
		end

		local opponentEvasionNum = target.evasion

		if opponentEvasionNum then
			local chanceToEvade = 1 - EVASION_CLIMB_RATE ^ -opponentEvasionNum
			if opponentEvasionNum > 0 then
				if math.random() > chanceToEvade then
					print(`{target.evolution.name} dodged the move.`)
					return true
				end
			end
		end

		local accuracyMult = EVASION_CLIMB_RATE ^ -opponentEvasionNum
		if math.random() > protomain.move.accuracy * accuracyMult then
			print(`{protomain.evolution.name}'s move missed.`)
			return true
		end

		return false
	end

	local function multipleEvades(protomains: { Typing.Protomain })
		local hits = {}
		for _, oneProtomain in protomains do
			if protomain ~= oneProtomain and not doesEvade(oneProtomain) then
				table.insert(protomain.moveHits, oneProtomain)
			end
		end
		return hits
	end

	if protomain.move.neverMissPriority <= 0 then
		local moveAffects = protomain.move.target
		if moveAffects == "opponent" or moveAffects == "ally" then
			if doesEvade(protomain.target) then
				return "evaded"
			end
		elseif moveAffects == "allProtomains" then
			protomain.moveHits = multipleEvades(protomain.battle.allProtomains)
		elseif moveAffects == "opponents" then
			protomain.moveHits = multipleEvades(protomain.battle.opponents)
		elseif moveAffects == "allies" then
			protomain.moveHits = multipleEvades(protomain.battle.allies)
		end
	end

	useMoveFunction(protomain)
	return "success"
end

return Move