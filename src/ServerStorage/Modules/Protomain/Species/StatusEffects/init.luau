local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Protomain = require(script.Parent.Parent)
local Turns = require(ServerStorage.Modules.Protomain.Battle.Turns)
local Move = require(ServerStorage.Modules.Protomain.Species.Moves.Move)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local StatusEffect = require(script.StatusEffect)
local Utils = require(game:GetService("ReplicatedStorage").Modules.Utils.Utils)

local StatusEffects = {}

-- true = continue, false = stop
-- local function turnChance(num: number, min: number, max: number, chance: number)
-- 	if num <= min then
-- 		return true
-- 	elseif num >= max then
-- 		return false
-- 	else
-- 		return math.random() > chance
-- 	end
-- end

local lastTurns = function(turns: number)
	return function(inflicted)
		return inflicted.statusEffectTurnNumber > turns
	end
end

StatusEffects.Burned = StatusEffect.new({
	endCondition = lastTurns(8),
	inflictCondition = function(inflicted, inflicter)
		return {
			Move.events.dealDamagingMove.connectBefore(
				function(attacker: Typing.Protomain, target: Typing.Protomain, mult: number?)
					if attacker == inflicted then
						print(
							`{inflicted.evolution.name} could not focus all its physical power on the move because it is burned.`
						)
						return { [3] = Utils.oneIfNil(mult) / 2 }
					end
					return {}
				end
			),
			Turns.events.playTurns.connectBefore(function(turns)
				print(`{inflicted.evolution.name} is burning.`)
				Protomain.takeFractionOfHealth(inflicted, 1 / 12)
			end),
		}
	end,
	description = "Takes damage every turn for 8 turns. Halfs melee attack and increases speed.",
})

-- StatusEffect.new{
-- 	name='Paralyzed',
-- 	endCondition=lastTurns(8),
-- 	beforeEvent=function(event: Event.StatusEffectEvent)
-- 		local isAfterTurns = event.name == 'turns'

-- 		if isAfterTurns then

-- 			input.inflicted.battle.move.speedMult *= 1/2 -- get Speed func
-- 			print(`{event.statusEffectInflicted.evolution.name} is burning.`)
-- 			Protomain.takeFractionOfHealth(event.statusEffectInflicted, 1/12)
-- 		end
-- 	end,

-- 	events={user={before={
-- 				['MoveFunction'] = function(input: Event.StatusEffectEventInput)
-- 					input.inflicted.battle.move.speedMult *= 1/2
-- 				end
-- 			},
-- 		}
-- 	},
-- 	description="The Protomain has a 50% chance to not move and has its speed cut in half (last for 8 turns)."
-- }

-- StatusEffect.new{
-- 	name='Poison',
-- 	endCondition=lastTurns(8),
-- 	events={
-- 		user={
-- 			after={
-- 				['Turns'] = function(input: Event.TurnsEventInput)
-- 					Protomain.takeFractionOfHealth(input.protomain, 1/12 + input.protomain * 1/36)
-- 				end
-- 			},
-- 		}
-- 	},
-- }

-- local function isAwake(awakeChance: number, inflicted: Protomain.Protomain)
-- 	local isAwake = math.random() > awakeChance

-- 	if isAwake then
-- 		Event.inflictStatusEffect(inflicted, "Alerted")
-- 	end

-- 	return isAwake
-- end

-- -- TODO add messages to moves

-- StatusEffect.new{
-- 	name='Sleep',
-- 	events={
-- 		user={
-- 			before={
-- 				['MoveFunction'] = function(input: Event.MoveEventInput)
-- 					local turnChance = ((input.turnNumber - 1) * (1/3))

-- 					input.protomain.battle.move = nil

-- 					Event.gainEnergy(input.protomain, 999)

-- 					local awakeChance = turnChance
-- 					return isAwake(awakeChance, input.protomain)
-- 				end
-- 			}
-- 		},
-- 		opponent={
-- 			after={
-- 				['MoveFunction'] = function(input: Event.OpponentStatusEffectEventInput)
-- 					if input.opponent.battle.target ~= input.inflicted then
-- 						return
-- 					end

-- 					local sleepDamage = (input.inflicted.battle.move.previousDamage / Protomain.getMaxHealth(input.inflicted))
-- 					local awakeChance = (sleepDamage + ((input.turnNumber - 1) * (1/3)))

-- 					return isAwake(awakeChance, input.inflicted)
-- 				end
-- 			}
-- 		}
-- 	}
-- }

-- StatusEffect.new{
-- 	name='Alerted',
-- 	events={
-- 		user={
-- 			after={
-- 				['Turns'] = function(input: Event.TurnsEventInput)
-- 					return false
-- 				end
-- 			}
-- 		},
-- 		opponent={
-- 			before={
-- 				['InflictStatusEffect'] = function(input: Event.OpponentStatusEffectEventInput)
-- 					if input.statusEffect.name == 'Sleep' then
-- 						return Event.StopEvent
-- 					end
-- 				end
-- 			}
-- 		},
-- 	}
-- }

--StatusEffect.new{
--	name='Frostbite',
--	targetedFunc=function(input: StatusEffect.StatusEffectTargetedInput)
--		if input.attacker.move.type_.name == "Fire" then
--			return false
--		elseif input.attacker.move.type_.name == "Ice" then
--			input.attacker.battle.move.damageMult += 1/2
--		end
--		return true
--	end,
--	func=function(input: Event.StatusEffectEventInput)
--		Protomain.takeFractionOfHealth(input.inflicted, 1/12)

--		return input.turnNumber <= 8
--	end
--}

---- defend, wait, rest buttons
--StatusEffect.new{
--	name='Frozen',
--	targetedFunc=function(input: StatusEffect.StatusEffectTargetedInput)
--		return input.attacker.move.type_.name ~= "Fire"
--	end,
--	func=function(input: Event.StatusEffectEventInput)
--		input.inflicted.move = nil

--		if input.turnNumber >= 5 then
--			return false
--		elseif input.turnNumber >= 3 then
--			return math.random() > 1/2
--		end
--		return true
--	end
--}

--StatusEffect.new{
--	name='Cold',
--	targetedFunc=function(input: Event.St)
--		return input.attacker.move.type_.name ~= "Fire"
--	end,
--	func=function(input: Event.StatusEffectEventInput)
--		if input.inflicted.battle.move.type_.name == 'Fire' then
--			return false
--		end

--		Protomain.takeFractionOfEnergy(input.inflicted, 1/8)
--		return true
--	end
--}

--StatusEffect.new{
--	name='Disoriented',
--	func=function(input: Event.StatusEffectEventInput)
--		if math.random() > 0.5 then
--			local newMove = Move.new({
--				name='Self Hit',
--				func=MoveFunction.basicDamageMove,
--				category="melee",
--				physicalContact=true,
--				type_=Types.types["Basic"],
--				energyCost=input.inflicted.move.energyCost,
--				description=".",
--				basePower=40,
--			})
--			input.inflicted.target = input.inflicted
--		end

--		if (input.turnNumber >= 2 and math.random() > 0.5) or input.turnNumber >= 4 then
--			return false
--		end

--		return true
--	end
--} --The Protomain has a 50% to hit themselves each turn the damage is dependent on the melee attack stat (last for 2-4 turns also disappears if switched out)

--StatusEffect.new{
--	name='Blinded',
--	targetedFunc=function(input: StatusEffect.StatusEffectTargetedInput)
--		if input.attacker.move.type_.name == "Light" then
--			input.attacker.move.damageMult = 1/2
--		end
--	end,
--	func=function(input: Event.StatusEffectEventInput)
--		local amountOfOpponents = #input.opponents
--		if amountOfOpponents < 2 then
--			if math.random() < 1/(amountOfOpponents + 1) then
--				input.inflicted.move = nil
--			else
--				local randomIndex = math.random(1, #input.opponents)
--				input.inflicted.target = input.opponents[randomIndex]
--			end
--		elseif math.random() < 0.8 then
--			input.inflicted.move = nil
--		end

--		return input.turnNumber <= 3
--	end
--}-- The Protomain has a 40% to completely miss an attack not counting support moves in double battles the missed attack can hit the other opposing Protomain or hit the teammate also light type moves won’t work on a blind Protomain(last for 3 turns)

---- effects slowly fade away?
--StatusEffect.new{
--	name='Deafened',
--	targetedFunc=function(input: StatusEffect.StatusEffectTargetedInput)
--		if input.attacker.move.type_.name == "Sound" then
--			input.attacker.move.damageMult *= 1/2
--		end
--	end,
--	func=function(input: Event.StatusEffectEventInput)
--		if math.random() < 0.8 then
--			input.inflicted.move = nil
--		end

--		return input.turnNumber <= 5
--	end
--}

--StatusEffect.new{
--	name='In Love',
--	func=function(input: Event.StatusEffectEventInput)
--		if input.inflicted.move.category ~= 'status' then
--			input.inflicted.move = nil
--		end
--		return input.turnNumber <= 3
--	end
--}

--StatusEffect.new{
--	name='Angry',
--	func=function(input: Event.StatusEffectEventInput)
--		if input.inflicted.move.category == 'status' then
--			input.inflicted.move = nil
--		end

--		input.inflicted.move.damageMult *= 1.25
--		input.inflicted.move.recoil += input.inflicted.move.basePower * (1/12)

--		return input.turnNumber <= 3
--	end
--}

--local previousHealFunction = Protomain.heal
--local previousStageFunction = Function.stageMove
--StatusEffect.new{
--	name='Angry',
--	func=function(input: Event.StatusEffectEventInput)
--		if input.inflicted.move.category == 'status' then
--			input.inflicted.move = nil
--		end

--		Protomain.heal = function(protomain, amount) Protomain.takeDamage(protomain, amount) end
--		Function.stageMove = function(stages, stat, target, input) return Function.stageMove(-stages, stat, target, input) end

--		if input.turnNumber >= 3 then
--			Protomain.heal = previousHealFunction
--			Function.stageMove = previousStageFunction
--			return false
--		end

--		return true
--	end
--}

--In Love😍- The Protomain can only use support moves (last for 3 turns)
--Angry😡- The Protomain can only use damaging moves and its attacks do a bit more damage but take a little recoil damage (last for 5 turns)

--Cursed🧙‍♀️- The Protomains positive stat changes and healing is reversed

--Deprived🪫- The Protomains moves cost 25% more energy (last for 5 turns)

--Energized🔋- The Protomains moves cost 25% less energy (last for 5 turns)

--Regenerated ❤️‍🩹- The Protomain gains a little bit of hp each turn (last for 7 turns)

return StatusEffects
