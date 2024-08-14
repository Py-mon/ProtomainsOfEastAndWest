task.wait(1)

local encounterAreas = workspace:WaitForChild("EncounterAreas"):GetChildren()

for _, area in encounterAreas do
	local folder = Instance.new("Folder")

	folder.Name = "Creatures"
	folder.Parent = area
end
