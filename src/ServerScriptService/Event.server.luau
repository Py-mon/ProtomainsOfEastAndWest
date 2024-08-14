local spawnedPerPlayer = {}
local timeFromLastSpawn = {}

local Event = game:GetService("ReplicatedStorage").Events.SpawnWild

Event.OnServerInvoke=(function(plr, protomain)
	if spawnedPerPlayer[plr.UserId] == nil then
		spawnedPerPlayer[plr.UserId] = {protomain}
		timeFromLastSpawn[plr.UserId] = 0
	else
		table.insert(spawnedPerPlayer[plr.UserId], protomain)
	end
	
	if time() - timeFromLastSpawn[plr.UserId] < 1.1 then
		print('EXPLOITING: SPAWNED TOO FAST')
		plr:Kick()
		return
	end
	
	timeFromLastSpawn[plr.UserId] = time()
	
	if #spawnedPerPlayer[plr.UserId] > 9 then
		print('EXPLOITING: SPAWNED TOO MANY')
		plr:Kick()
		return
	end
end)

local CatchProtomain = game:GetService("ReplicatedStorage").Events.CatchProtomain
local isIn = require(game:GetService("ReplicatedStorage").Modules.Utils.Utils).isIn


CatchProtomain.OnServerInvoke = (function(plr, protomain)
	print(spawnedPerPlayer[plr.UserId], protomain.id, isIn(protomain, spawnedPerPlayer[plr.UserId]))
	
	local function invoked()
		for _, proto in spawnedPerPlayer[plr.UserId] do
			if proto.id == protomain.id then
				return true
			end
		end
		return false
	end
	if spawnedPerPlayer[plr.UserId] == nil or not invoked() then
		print('EXPLOITING: DIDNT INVOKE SERVER')
		plr:Kick()
		return
	end
	
	print('CAUGHT')
	
	--local setSuccess, errorMessage = pcall(function()
	--    protomains:SetAsync(plr.UserId, spawnedPerPlayer[plr.UserId])
	--end)

	--local getSuccess, currentGold = pcall(function()
	--    return protomains:GetAsync(plr.UserId)
	--end)

	--if getSuccess then
	--    print(currentGold)
	--end
end)