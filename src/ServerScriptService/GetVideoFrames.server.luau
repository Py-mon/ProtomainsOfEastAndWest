function getVideoFrames(name: string)
	local frames = {}
	local cursor = nil

	repeat
		local url = "https://inventory.roproxy.com/v2/users/823085822/inventory?assetTypes=Decal&limit=100&sortOrder=Asc"

		if cursor then
			url = url .. "&cursor=" .. cursor
		end

		local data = HttpService:JSONDecode(HttpService:GetAsync(url))

		for _, v in pairs(data.data) do
			if not string.find(v.name, name) then
				continue
			end

			local numberIndex = #v.name - string.reverse(v.name):find("_")

			if not (string.sub(v.name, 1, numberIndex) == "Images/" .. name) then
				continue
			end

			print(v.name)
			local frameNumber = tonumber(string.sub(v.name, numberIndex + 2, #v.name))
			if not frameNumber then
				continue
			end
			frames[frameNumber] = "rbxassetid://" .. tostring(v.assetId)
		end

		if data.nextPageCursor then
			cursor = data.nextPageCursor
		end

	until not data.nextPageCursor

	return frames
end

print(getVideoFrames("encounter_exclamation_point_frame"))
