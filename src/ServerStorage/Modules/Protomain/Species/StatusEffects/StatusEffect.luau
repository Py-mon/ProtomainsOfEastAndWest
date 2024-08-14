local ServerStorage = game:GetService("ServerStorage")
local StatusEffect = {}

local ProtomainsFolder = game:GetService("ReplicatedStorage").Modules.Protomains
local CreateBattleEvent = require(ServerStorage.Modules.Protomain.Battle.CreateBattleEvent)
local Typing = require(ProtomainsFolder.Typing)

function StatusEffect.new(array)
	local self = array :: Typing.StatusEffect

	return self
end

StatusEffect.events = {}

StatusEffect.events.inflictStatusEffect, StatusEffect.inflictStatusEffect = CreateBattleEvent(
	function(statusEffect: Typing.StatusEffect, on: Typing.Protomain)
		on.statusEffect = statusEffect
		on.statusEffectTurnNumber = 1
		statusEffect.inflictCondition(on)
	end
)

StatusEffect.events.healStatusEffect, StatusEffect.healStatusEffect = CreateBattleEvent(
	function(protomain: Typing.Protomain)
		protomain.statusEffect = nil
		protomain.statusEffectTurnNumber = 0
	end
)

return StatusEffect

-- for _, protomain in turns.battle.allProtomains do
--     protomain.statusEffectTurnNumber += 1

--     if protomain.statusEffect and protomain.statusEffect.endCondition(protomain) then
--         protomain.statusEffect.endMessage()
--         protomain.statusEffect = nil
--     end
-- end
-- disconnect
