local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Types = require(ServerStorage.Modules.Protomain.Battle.Types)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local Move = require(script.Move)
local Protomain = require(script.Parent.Parent)

--[[
    Database of Moves
]]
local Moves = {}

local damageMove = function(protomain)
	Move.basicFuncs.dealDamagingMove(protomain, protomain.target)
end

Moves.Leaflet = Move.new({
	func = damageMove,
	category = "ranged",
	type_ = Types.Nature,
	energyCost = 20,
	description = "Shoot the foe with somewhat sharp leaves.",
	basePower = 40,
})

Moves.Spray = Move.new({
	func = damageMove,
	category = "ranged",
	type_ = Types.Water,
	energyCost = 20,
	description = "Shoot a light stream of water at the foe.",
	basePower = 40,
})

local MAY = 1 / 8
Moves.Bubble = Move.new({
	func = function(protomain: Typing.Protomain)
		damageMove(protomain)

		if math.random() < MAY then
			Protomain.stageChange(protomain.target, "speed", -1)
		end
	end,
	category = "ranged",
	type_ = Types.Water,
	energyCost = 20,
	description = "Blow small bubbles at the foe. May lower the foe's speed.",
	basePower = 40,
})

Moves.Slam = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Basic,
	energyCost = 35,
	description = "Bash the foe with decent force.",
	basePower = 60,
})

Moves.Tackle = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Basic,
	energyCost = 20,
	description = "Ram into the foe with a weak physical attack.",
	basePower = 40,
})

Moves.Pounce = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Basic,
	energyCost = 20,
	description = "Spring at the foe.",
	basePower = 40,
})

Moves.Scratch = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Basic,
	energyCost = 20,
	description = "Claw the foe.",
	basePower = 40,
	bodyPart = "claws",
})

Moves.Pound = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Basic,
	energyCost = 20,
	description = "Smack the foe to the ground.",
	basePower = 40, -- weight based? allow to pass function to calculate
})

Moves.Growl = Move.new({
	func = function(protomain: Typing.Protomain)
		Protomain.stageChange(protomain.target, "meleeAttack", -1)
	end,
	category = "status",
	type_ = Types.Sound,
	energyCost = 10,
	description = "Let out a small roar. Lowers the foe's melee attack.",
})

Moves.Leer = Move.new({
	name = "Leer",
	func = function(protomain: Typing.Protomain)
		Protomain.stageChange(protomain.target, "meleeDefense", -1)
	end,
	category = "status",
	type_ = Types.Basic,
	energyCost = 10,
	description = "Stare at the foe. Lowers their melee defense.",
})

Moves.TailWag = Move.new({
	func = function(protomain: Typing.Protomain)
		Protomain.stageChange(protomain.target, "meleeDefense", -1)
	end,
	category = "status",
	type_ = Types.Basic,
	energyCost = 10,
	description = "Wag your tail at your foe. Lowers their melee defense.",
})

Moves.Bite = Move.new({
	func = damageMove, -- TODO plus flinching
	category = "melee",
	physicalContact = true,
	type_ = Types.Dark,
	energyCost = 25,
	description = "Chomp down on the foe. May cause flinching.",
	basePower = 60,
	bodyPart = "teeth",
})

Moves.QuickStrike = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Dark,
	energyCost = 25,
	description = "Sprint at the foe and strike. Usually goes first.",
	basePower = 60,
	priority = 1,
})

Moves.IceSpear = Move.new({
	func = damageMove,
	category = "ranged",
	type_ = Types.Ice,
	energyCost = 40,
	description = "Puncture straight through the foe with a spear made out of solid ice.",
	basePower = 80,
})

Moves.JetStrike = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Air,
	energyCost = 25,
	description = "Fly at a high speed at the foe. Usually goes first.",
	basePower = 40,
	priority = 1,
})

Moves.JetStream = Move.new({
	func = damageMove,
	category = "ranged",
	type_ = Types.Air,
	energyCost = 25,
	description = "Shoot a strong and fast current at the foe. Usually goes first.",
	basePower = 40,
	priority = 1,
})

Moves.AquaJet = Move.new({
	func = damageMove,
	category = "melee",
	type_ = Types.Water,
	energyCost = 25,
	description = "Beam water at the foe at high speeds. Usually goes first.",
	basePower = 40,
	priority = 1,
})

Moves.BugBite = Move.new({
	func = function(protomain: Typing.Protomain) -- heals a 1/8 of damage done after move
		local healthBefore = Protomain.get.health(protomain.target)

		damageMove(protomain)

		local healthAfter = Protomain.get.health(protomain.target)

		local damage = healthBefore - healthAfter
		Protomain.heal(protomain, damage / 8)
	end,
	category = "melee",
	physicalContact = true,
	type_ = Types.Bug,
	energyCost = 20,
	description = "Bite the foe, sucking some blood to regain some of the user's health.",
	basePower = 20,
	bodyPart = "teeth",
})

Moves.SlikShot = Move.new({
	func = function(protomain: Typing.Protomain)
		for _, opponent in protomain.moveHits do
			Protomain.stageChange(opponent, "speed", -1)
		end
	end,
	category = "status",
	target = "allOpponents",
	type_ = Types.Bug,
	energyCost = 15,
	description = "Shoot light silk at the foes. Lowers all the foes' speeds.",
})

Moves.Peck = Move.new({
	func = damageMove,
	category = "melee",
	physicalContact = true,
	type_ = Types.Bug,
	energyCost = 15,
	description = "Tap the foe with your beak.",
	basePower = 40,
	bodyPart = "nose",
})

Moves.Squawk = Move.new({
	func = function(protomain: Typing.Protomain)
		Protomain.stageChange(protomain.target, "meleeAttack", -1)
	end,
	category = "status",
	type_ = Types.Sound,
	energyCost = 10,
	description = "Screech at the foe with bird sounds. This will lower the foe's melee attack.",
})

--Peck	Air	Melee	40	20	100%	Yes		"""Tap the foe with your beak""."
--Squawk	Sound	Status	      N/A	10	100%	No		"""Screech at the foe with bird sounds this will lower the foes melee attack""."
--Powder Snow	Ice	Ranged	35	15	100%	No		"""Puff some snow at the foe this may cause the foe to become cold""."
--Splash	Water	Ranged	35	15	100%	No		"""Splash into the water to damage the foe""."
--Mud Splash	Earth	Ranged	35	15	100%	No		Splash into muddy water to damage the foe".
--Work Up	Basic	Status	       N/A	25	N/A	No		"""Focus your energy on raiseing your strengh this will raise the users melee and ranged attack""."
--Kick	Brawler	Melee	40	20	100%	Yes		"""Use your foot to hit the foe""."
--Punch	Brawler	Melee	40	20	100%	Yes		"""Use your fist to hit the foe""."
--Sing	Sound	Status	       N/A	30	75%	No		"""Sing the foe a sweet melody this will put them to sleep""."
--Pebble Toss	Mineral	Melee	40	20	100%	No		"""Toss a small stone at the foe""."
--Confusion	Mind	Ranged	50	25	100%	No		"""Use a small amount of psychic power at the foe""."
--Slime	Toxic	Ranged	35	15	100%	No		"""Shoot some goo at the foe, this may cause poison""."
--Clamp	Iron	Melee	50	20	100%	Yes		"""Pinch the foe with a metal hand""."
--Shine	Light	Ranged	40	20	100%	No		"""Shine some light onto the foe this may cause blindness""."
--Scream	Sound	Ranged	40	20	100%	No		"""Scream at the foe this may cause deafness""."
--Mud Shot	Earth	Ranged	25	15	100%	No		"""Shoot some mud at the foe, this may lower accuracy""."
--Firm Up	Basic	Status	       N/A	15	100%	No		"""Harden your muscles and tissues and raise your melee defense""."
--Dark Pint	Dark	Ranged	35	15	100%	No		"""Shoot a small amount of dark energy at the foe'."
--Fright	Spirit	Melee	35	15	100%	Yes		"""Scare the foe, this may cause flinching""."
--Sweet Voice 	Mystic	Ranged	35	15	100%	No		"""Sing a lovely tune that damages the foe'."
--Wire Whip	Cyber	Melee	40	20	100%	Yes		"""Slap the foe with a wire""."
--Dwarf Star	Cosmic	Ranged	30	15	100%	No		"""Shoot a tiny star at the foe"""
--Stomp	Basic	Melee	50	25	100%	Yes		"""Step on the foe, this may cause flinching""."
--Horn Attack	Basic	Melee	50	25	100%	Yes		"""Ram your horn into the foe""."
--Cold Breeze	Ice	Ranged	55	30	95%	No		"""Blow icy wind at the foe, this will always lower their speed and may cause them to get cold""."

local NewIndex = Moves
for name, move in Moves do
	move.name = name
end

return NewIndex
