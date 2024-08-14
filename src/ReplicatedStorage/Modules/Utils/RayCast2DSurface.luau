local RayCast2DSurface = {}

local function getBoundingHeight(part)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = CFrame.new():toObjectSpace(part.CFrame):GetComponents()

	local height = (math.abs(R10) * part.Size.X + math.abs(R11) * part.Size.Y + math.abs(R12) * part.Size.Z)

	return height
end

function RayCast2DSurface.new(part)
	local self = {}

	self.part = part

	self.params = RaycastParams.new()
	self.params.FilterDescendantsInstances = { self.part }
	self.params.FilterType = Enum.RaycastFilterType.Include

	self.vary = getBoundingHeight(self.part) / 2 + 1

	return self
end

function RayCast2DSurface.partIsAbove(rayCast2DSurface, position)
	rayCast2DSurface.params.FilterType = Enum.RaycastFilterType.Exclude

	local mult = 5
	-- fix

	local result = workspace:Raycast(
		Vector3.new(position.X, rayCast2DSurface.part.Position.Y + rayCast2DSurface.vary * mult, position.Y), -- (position.Y = Z)
		Vector3.new(0, -rayCast2DSurface.vary * mult - (rayCast2DSurface.vary - 1), 0),
		rayCast2DSurface.params
	)
	--print(result)
	--return false
	return result ~= nil
end

function RayCast2DSurface._cast(rayCast2DSurface, position)
	local result = workspace:Raycast(
		Vector3.new(position.X, rayCast2DSurface.part.Position.Y + rayCast2DSurface.vary, position.Y), -- (position.Y = Z)
		Vector3.new(0, -rayCast2DSurface.vary * 2, 0),
		rayCast2DSurface.params
	)
	return result
end

function RayCast2DSurface.getY(rayCast2DSurface, position)
	local result = RayCast2DSurface._cast(rayCast2DSurface, position)

	if result == nil or result.Instance ~= rayCast2DSurface.part then
		return false
	end

	return result.Position.Y
end

function RayCast2DSurface.cast(rayCast2DSurface, position)
	local result = RayCast2DSurface._cast(rayCast2DSurface, position)

	return result ~= nil
end

return RayCast2DSurface
