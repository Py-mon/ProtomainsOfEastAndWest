local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreateBattleEvent = require(script.Battle.CreateBattleEvent)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local Utils = require(ReplicatedStorage.Modules.Utils.Utils)
local Stats = require(script.Stats)

-- CONSTANTS
local GLOSSY = {
	CHANCE = 1 / 4096, -- Chance for a Protomain to be glossy
	STAT_BONUS = 3, -- Stat Bonus of Glossies (might be too OP... maybe make more Quality of Life)
	-- all effort instantly?
	-- guariteed stats
}

local MODEL = {
	MINIMUM_SIZE_MULT = 0.75,
	MAXIMUM_SIZE_MULT = 1.50,
}

local POINTS = {
	BASE = 5,
	DIVIDER = 40,

	BASE_STAT_WEIGHT = 2,

	HEALTH = {
		BASE = 10,
		DIVIDER = 40,
	},
	ENERGY = {
		BASE = 80,
		DIVIDER = 25,
	},
}

local EXPERIENCE = {
	BASE = 100,
	CLIMB_RATE = 2,
}

local EFFORT = {
	FILL_POINTS = 3,
}
local STAGE = {
	STEP = 0.50,
	MAXIMUM = 6,
	MINIMUM = -6,
}

--local ExperienceGainDivider = 20
--local WildExperienceMult = 1.5

--[[
    Stores protomain functions and events that relate to the Protomain's stats, leveling, and experience.
]]
local Protomain = {}

function Protomain.new(
	species: Typing.Species,
	_nickname: string?,
	isWild: boolean?,
	startingStage: number?
): Typing.Protomain
	local self = {} :: Typing.Protomain

	self.id = Utils.createUniqueID()

	self.species = species

	self._evolution = startingStage or 1
	self.evolution = self.species.evolutions[self._evolution]

	self.abilities = {}

	for _, ability in self.evolution.setAbilities do
		table.insert(self.abilities, ability)
	end

	if #self.evolution.chanceAbilities > 0 then
		table.insert(self.abilities, Utils.weightedRandom(self.evolution.chanceAbilities))
	end

	self.nickname = self.nickname or self.evolution.name

	self.effortStats = Stats.createAddedStats()
	self.effortPoints = 0

	self.size = math.random(MODEL.MINIMUM_SIZE_MULT, MODEL.MAXIMUM_SIZE_MULT)

	self.isMale = math.random() < self.species.maleChance
	self.isGlossy = math.random() < GLOSSY.CHANCE
	self.isWild = isWild or true

	self.level = 1
	self._experience = 0

	self._damageTaken = 0
	self.statusEffectTurnNumber = 0

	self.stages = Stats.createStats0() -- reset when switching

	-- reset after battle
	self._energyUsed = 0
	self.evasion = 0 -- -1 -> get hit more, +1 dodge more often

	return self
end

function Protomain.display(protomain: Typing.Protomain)
	print(`{protomain.evolution.name} - {protomain.id}`)
end

local function getTotalStatPoints(protomain: Typing.Protomain, stat: Typing.Stat)
	local points = (
		(protomain.evolution.baseStats[stat] * POINTS.BASE_STAT_WEIGHT)
		+ protomain.effortStats[stat]
		+ Protomain.get.glossyBonus(protomain)
	)
	return points * protomain.level
end

local function getMax(protomain: Typing.Protomain, stat: Typing.Stat, divider: number, base: number): number
	return getTotalStatPoints(protomain, stat) / divider + base
end

Protomain.getMax = {
	energy = function(protomain: Typing.Protomain)
		return getMax(protomain, "energy", POINTS.ENERGY.DIVIDER, POINTS.ENERGY.BASE)
	end,

	health = function(protomain: Typing.Protomain)
		return getMax(protomain, "health", POINTS.HEALTH.DIVIDER, POINTS.HEALTH.BASE)
	end,

	stat = function(protomain: Typing.Protomain, stat: Typing.NormalStat)
		return getMax(protomain, stat, POINTS.DIVIDER, POINTS.BASE)
	end,
}

Protomain.get = {
	glossyBonus = function(protomain: Typing.Protomain)
		return Utils.boolToNum(protomain.isGlossy) * GLOSSY.STAT_BONUS
	end,

	stat = function(protomain: Typing.Protomain, stat: Typing.NormalStat)
		return (
			Protomain.getMax.stat(protomain, stat) * Utils.getMultiplierFromStage(protomain.stages[stat], STAGE.STEP)
		)
	end,

	energy = function(protomain: Typing.Protomain)
		return Protomain.getMax.energy(protomain) - protomain._energyUsed
	end,

	health = function(protomain: Typing.Protomain)
		return Protomain.getMax.health(protomain) - protomain._damageTaken
	end,
}

function Protomain.evolve(protomain: Typing.Protomain)
	protomain._evolution += 1
	protomain.evolution = protomain.species.evolutions[protomain._evolution]
end

function Protomain.checkLevelUp(protomain: Typing.Protomain)
	while protomain._experience >= Protomain.getExperience.totalToLevel(protomain) do
		protomain._experience -= Protomain.getExperience.totalToLevel(protomain)
		protomain.level += 1
	end
end

Protomain.getExperience = {
	totalToLevel = function(protomain: Typing.Protomain): number
		return math.round(protomain.level ^ EXPERIENCE.CLIMB_RATE) + EXPERIENCE.BASE
	end,
	toLevel = function(protomain: Typing.Protomain): number
		return Protomain.getExperience.totalToLevel(protomain) :: number - protomain._experience
	end,
}

--function protomain.calculateExperienceGain(defeatedProtomain: Typing.Protomain)
--	local points = (Stage.getStatTotal(defeatedProtomain.evolution) * defeatedProtomain.level) / Stat.numberOfStats / ExperienceGainDivider
--	-- if on bench add 0.25x

--	local wild = if protomain.isWild then 1 else WildExperienceMult
--	local faint = if defeatedProtomain.getHealth() == 0 then 0 else 1
--	return math.round(points * faint)
--end

Protomain.effort = {
	usePoint = function(protomain: Typing.Protomain, stat: Typing.Stat)
		if protomain.effortPoints <= 0 then
			return
		end

		protomain.effortStats[stat] += 1
		protomain.effortPoints -= 1
	end,

	fill = function(protomain: Typing.Protomain)
		protomain.effortPoints += EFFORT.FILL_POINTS
	end,
}

Protomain.set = {
	move = function(protomain: Typing.Protomain, move: Typing.Move)
		protomain.move = move
	end,

	target = function(protomain: Typing.Protomain, target: Typing.Protomain)
		protomain.target = target
	end,
}

Protomain.events = {}

Protomain.events.heal, Protomain.heal = CreateBattleEvent(function(protomain: Typing.Protomain, amount: number)
	protomain._damageTaken -= amount
	protomain._damageTaken = math.max(protomain._damageTaken, 0)
end)

Protomain.events.gainEnergy, Protomain.gainEnergy = CreateBattleEvent(
	function(protomain: Typing.Protomain, amount: number)
		protomain._energyUsed -= amount
		protomain._energyUsed = math.max(protomain._energyUsed, 0)
	end
)

Protomain.events.useEnergy, Protomain.useEnergy = CreateBattleEvent(
	function(protomain: Typing.Protomain, amount: number)
		local energyBefore = Protomain.get.energy(protomain)
		protomain._energyUsed += amount
		protomain._energyUsed = math.min(protomain._energyUsed, energyBefore)
	end
)

Protomain.events.takeDamage, Protomain.takeDamage = CreateBattleEvent(
	function(protomain: Typing.Protomain, amount: number)
		local healthBefore = Protomain.get.health(protomain)
		protomain._damageTaken += amount
		protomain._damageTaken = math.min(protomain._damageTaken, healthBefore)
	end
)

Protomain.events.stageChange, Protomain.stageChange = CreateBattleEvent(
	function(protomain: Typing.Protomain, stat: Typing.Stat, stages: number)
		protomain.stages[stat] += stages

		if stages < STAGE.MINIMUM then
			protomain.stages[stat] = STAGE.MINIMUM
		elseif stages > STAGE.MAXIMUM then
			protomain.stages[stat] = STAGE.MAXIMUM
		end
	end
)

function Protomain.takeFractionOfHealth(protomain: Typing.Protomain, amount: number)
	Protomain.takeDamage(protomain, Protomain.getMax.health(protomain) * amount)
end
function Protomain.takeFractionOfEnergy(protomain: Typing.Protomain, amount: number)
	Protomain.useEnergy(protomain, Protomain.getMax.energy(protomain) * amount)
end

return Protomain
