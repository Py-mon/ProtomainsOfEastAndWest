local ServerStorage = game:GetService("ServerStorage")

local Types = require(ServerStorage.Modules.Protomain.Battle.Types)
local Species = require(script.SpeciesConstructor)
local model = game:GetService("ReplicatedStorage").Models.Model.Chitbox
local Abilities = require(script.Abilities)
local Stage = require(script.Stage)

local AllSpecies = {}

AllSpecies.Floricri = Species.new({
	evolutions = {
		Stage.new({
			name = "Floricri", -- (FLOOR-E)
			baseStats = {
				health = 55,
				energy = 50,
				meleeAttack = 35,
				meleeDefense = 55,
				rangedAttack = 68,
				rangedDefense = 65,
				speed = 20,
				-- 350
			},
			model = model,
			--moves={Move.index["Magic Move"]},
			--setAbilities = { Abilities.Timid },
			types = { Types.Nature },
		}),
		Stage.new({
			name = "Raspaca", -- (RAS-PAC-A)
			baseStats = {
				health = 70,
				energy = 65,
				meleeAttack = 40,
				meleeDefense = 58,
				rangedAttack = 86,
				rangedDefense = 83,
				speed = 48,
				-- 450
			},
			model = model,
			setAbilities = { Abilities.Timid },
			types = { Types.Water },
		}),
		Stage.new({
			name = "Llameadow", -- LA-MEADOW
			baseStats = {
				health = 119,
				energy = 85,
				meleeAttack = 52,
				meleeDefense = 70,
				rangedAttack = 123,
				rangedDefense = 98,
				speed = 53,
				-- 600
			},
			model = model,
			--setAbilities={AbilityIndex.abilities['Magic Power']},
			types = { Types.Nature },
		}),
	},
})

return AllSpecies
