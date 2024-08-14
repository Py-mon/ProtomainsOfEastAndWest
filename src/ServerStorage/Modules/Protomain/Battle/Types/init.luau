--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TypeChart = require(script.TypeChart)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local Utils = require(ReplicatedStorage.Modules.Utils.Utils)

local TypeChartOrder = {
	"Basic",
	"Fire",
	"Water",
	"Electric",
	"Nature",
	"Ice",
	"Brawler",
	"Toxic",
	"Earth",
	"Air",
	"Mind",
	"Bug",
	"Mineral",
	"Spirit",
	"Dragon",
	"Dark",
	"Metal",
	"Mystic",
	"Light",
	"Sound",
	"Cyber",
	"Cosmic",
}

local Types = {} :: {
	Basic: Typing.Type,
	Fire: Typing.Type,
	Water: Typing.Type,
	Electric: Typing.Type,
	Nature: Typing.Type,
	Ice: Typing.Type,
	Brawler: Typing.Type,
	Toxic: Typing.Type,
	Earth: Typing.Type,
	Dark: Typing.Type,
	Air: Typing.Type,
	Mind: Typing.Type,
	Bug: Typing.Type,
	Mineral: Typing.Type,
	Spirit: Typing.Type,
	Dragon: Typing.Type,
	Metal: Typing.Type,
	Mystic: Typing.Type,
	Light: Typing.Type,
	Sound: Typing.Type,
	Cyber: Typing.Type,
	Cosmic: Typing.Type,
	getMultiplierBetween: (Typing.Type, Typing.Type) -> number,
}

local function newType(name: Typing.Types, mults: { [Typing.Types]: number })
	local self = {} :: Typing.Type

	self.name = name
	self.mults = mults

	return self
end

--[[
    Go through the type chart and create the Types.
]]
function parseTypeChart()
	for _, element, _, row in Utils.combinedPairs(TypeChartOrder, TypeChart) do
		local mults = {}
		for _, element2, _, mult2 in Utils.combinedPairs(TypeChartOrder, row) do
			mults[element2] = mult2
		end
		table.insert(newType(element, mults), Types)
	end
end

parseTypeChart()

function Types.getMultiplierBetween(types1: { Typing.Type }, types2: { Typing.Type })
	local mult = 1
	for _, defendType in types2 do
		for _, attackType in types1 do
			mult *= attackType.mults[defendType.name] or 1
		end
	end
	return mult
end

return Types
