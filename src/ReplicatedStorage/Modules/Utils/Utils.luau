local Utils = {}

local ids = {}

local ID_DIGITS = 6

--[[
    Creates an unique number idenifier.
]]
function Utils.createUniqueID()
	local id = math.round(math.random() * 10 ^ ID_DIGITS)

	local found = table.find(ids, id)
	if found then
		return Utils.createUniqueID()
	end

	table.insert(ids, id)
	return id
end

--[[
    Convert a boolean value to a number.
    ```
    true -> 1
    false -> 0
]]
function Utils.boolToNum(bool: boolean)
	return if bool then 1 else 0
end

--[[
    Get the multiplier from a stage.
    ```
    ...
    stage -3 with a 50% vary -> 2/5x
    stage -2 with a 50% vary -> 1/2x
    stage -1 with a 50% vary -> 1/3x
    stage  0 with a 50% vary -> 1.0x
    stage +1 with a 50% vary -> 1.5x
    stage +2 with a 50% vary -> 2.0x
    stage +3 with a 50% vary -> 2.5x
    ...
]]
function Utils.getMultiplierFromStage(stage: number, step: number)
	if stage < 0 then
		return 1 / (-stage * step + 1)
	else
		return (stage * step + 1) / 1
	end
end

--[[
    Get a random item from an table of weights.
    ```
    {0.2: "apple", 0.5: "pear", 0.3: "mango"} 
    -> 20% chance of "apple", 50% chance of "pear", 30% chance of "mango"
]]
function Utils.weightedRandom(rarities: { [number]: any })
	local RollTable = {}

	for frequency, object_name in rarities do
		frequency = frequency * 100
		for _ = 1, frequency do
			table.insert(RollTable, object_name)
		end
	end

	return RollTable[math.random(1, #RollTable)]
end

--[[
    Returns `1` if x is `nil` otherwise returns `x`
]]
function Utils.oneIfNil(x: any)
	if x == nil then
		return 1
	end
	return x
end

--[[
    Wether `inside` is in `objects`
]]
function Utils.isIn(inside: any, objects: { any }): boolean
	if table.find(objects, inside) ~= nil then
		return true
	end
	return false
end

--[[
    Merge multiple arrays into one.
]]
function Utils.combineArrays<A, B, C>(a: A, b: B, c: C?): A & B & C
	local newArray = {}
	for _, array in { a, b, c } do
		for _, item in array do
			table.insert(newArray, item)
		end
	end
	return newArray
end

-- Someonelses code - https://devforum.roblox.com/t/combinedPairs-loop-through-several-tables-in-one-loop/785728
function Utils.combinedPairs(...)
	local Tables = { ... }
	for Idx, Obj in next, Tables do
		assert(type(Obj) == "table", "Bad argument #" .. Idx .. " (table expected, got " .. typeof(Obj) .. ")")
	end

	local NumInput = #Tables

	local Idx = nil
	local Working = table.create(NumInput, true)

	return function()
		local Returns = {}
		local IsEmpty = true

		for TableIdx, Table in next, Tables do
			if Working[TableIdx] then
				local Worked, Val, Key = pcall(next, Table, Idx)

				if Worked == false and Key == nil then
					Working[TableIdx] = false
					continue
				end
				IsEmpty = false

				Returns[#Returns + 1] = Val
				Returns[#Returns + 1] = Key
			end
		end

		if IsEmpty then
			return
		end

		Idx = Idx and Idx + 1 or 1
		return unpack(Returns)
	end
end

return Utils