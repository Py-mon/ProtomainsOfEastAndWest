local DataStoreService = game:GetService("DataStoreService")

local protomains = DataStoreService:GetDataStore("Protomains")


game.Players.PlayerAdded:Connect(function(plr)
	local playerId = plr.UserId

	local setSuccess, errorMessage = pcall(function()
		protomains:SetAsync(playerId, 5)
	end)
	if not setSuccess then
		warn(errorMessage)
	end

	task.wait(5)

	-- Read data store key
	local getSuccess, currentGold = pcall(function()
		return protomains:GetAsync(playerId)
	end)
	if getSuccess then
		print(currentGold)
	end
end)
