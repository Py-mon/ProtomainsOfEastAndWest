task.wait(5)
local ServerStorage = game:GetService("ServerStorage")
local Protomain = require(ServerStorage.Modules.Protomain)
local Battles = require(ServerStorage.Modules.Protomain.Battle.Battles)
local Moves = require(ServerStorage.Modules.Protomain.Species.Moves)
local Turns = require(ServerStorage.Modules.Protomain.Battle.Turns)
local Species = require(ServerStorage.Modules.Protomain.Species)
local StatusEffects = require(ServerStorage.Modules.Protomain.Species.StatusEffects)
local StatusEffect = require(ServerStorage.Modules.Protomain.Species.StatusEffects.StatusEffect)

print("START")

local protomain1 = Protomain.new(Species.Floricri, nil, nil, 1)

local protomain2 = Protomain.new(Species.Floricri, nil, nil, 2)

game:GetService("ReplicatedStorage").Events.GetProtomain.OnServerInvoke = function()
	if math.random() > 0.5 then
		return protomain1
	end
	return protomain2
end

-- Create a Battle between protomain1 and protomain2
local battle = Battles.start({ protomain1 }, { protomain2 })

-- Set the move and move's target
protomain1.move = Moves.Leaflet
protomain1.target = protomain2

-- inflict the status effect burn onto protomain1
StatusEffect.inflictStatusEffect(StatusEffects.Burned, protomain1)

-- Create a round of turns and run the turns
local turns = Turns.new(battle)
print("stage", protomain2.stages.meleeAttack, protomain2.stages.speed)
Turns.playTurns(turns)
-- protomain1 is the only one with a move so it is the only on who goes

-- Get statss
print(protomain1.nickname, "energy", Protomain.getMax.energy(protomain1))
print(protomain2.nickname, "health", Protomain.getMax.health(protomain2))

print(protomain1.nickname, "health", Protomain.getMax.health(protomain1))

print(protomain2._damageTaken)

print(protomain1.nickname, "energy", Protomain.get.energy(protomain1))
print(protomain2.nickname, "health", Protomain.get.health(protomain2))

print(protomain1.nickname, "health", Protomain.get.health(protomain1))

print("stage", protomain2.stages.meleeAttack, protomain2.stages.speed)