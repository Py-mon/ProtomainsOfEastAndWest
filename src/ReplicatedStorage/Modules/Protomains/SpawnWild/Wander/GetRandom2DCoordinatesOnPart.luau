local RayCast2DSurface = require(game:GetService("ReplicatedStorage").Modules.Utils.RayCast2DSurface)

function getRandom2DCoordinatesOnPart(part: Part)
	local ray = RayCast2DSurface.new(part)

	local function recast()
		local sizeX = part.Size.X
		local randomX = math.random() * sizeX + part.Position.X - sizeX / 2

		local sizeZ = part.Size.Z
		local randomZ = math.random() * sizeX + part.Position.Z - sizeX / 2

		return randomX, RayCast2DSurface.getY(ray, Vector2.new(randomX, randomZ)), randomZ
	end

	local x, y, z
	repeat
		x, y, z = recast()
	until y

	local coordinates = Vector3.new(x, y, z)

	return coordinates
end

return getRandom2DCoordinatesOnPart
