game.Players.PlayerAdded:Connect(function(plr)
	if plr:GetRankInGroup(32056608) < 200 then
		plr:Kick("This is in the works of being developed. Come back soon!")
	end
end)
