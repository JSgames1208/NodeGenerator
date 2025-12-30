--!strict

local HttpService = game:GetService("HttpService")

local Random = Random.new()

--------------------------
-- CONFIGURATION
--------------------------

local NodeGenerator = {}

NodeGenerator.areaWidth = 100
NodeGenerator.areaHeight = 100
NodeGenerator.minSpacing = 5
NodeGenerator.regenMinDelay = 2
NodeGenerator.regenMaxDelay = 5
NodeGenerator.seed = nil

--------------------------
-- INTERNAL STATE
--------------------------

local NodeState: { Node } = {}
local NodePoints: { Vector2 } = {}
local RegenActive = false

--------------------------
-- UTILITIES
--------------------------

export type Node = {
	id: string,
	position: Vector2,
}

--basic maxheap implementation
local MaxHeap = {}
MaxHeap.__index = MaxHeap

export type MaxHeap<T> = {
	items: { { key: number, value: T } },
	push: (self: MaxHeap<T>, key: number, value: T) -> (),
	pop: (self: MaxHeap<T>) -> (number?, T?),
	isEmpty: (self: MaxHeap<T>) -> boolean,
} & typeof(setmetatable({} :: MaxHeap<T>, MaxHeap))

function MaxHeap.new<T>(): MaxHeap<T>
	return setmetatable({ items = {} }, MaxHeap) :: MaxHeap<T>
end

function MaxHeap.push<T>(self: MaxHeap<T>, key, value: T)
	table.insert(self.items, { key = key, value = value })
	local i = #self.items
	while i > 1 do
		local parent = math.floor(i / 2)
		if self.items[parent].key >= self.items[i].key then
			break
		end
		self.items[parent], self.items[i] = self.items[i], self.items[parent]
		i = parent
	end
end

function MaxHeap.pop<T>(self: MaxHeap<T>): (number?, T?)
	local items = self.items
	if #items == 0 then
		return nil
	end
	local top = items[1]
	items[1] = items[#items]
	table.remove(items)
	local i = 1
	while true do
		local left = 2 * i
		local right = 2 * i + 1
		local largest = i
		if left <= #items and items[left].key > items[largest].key then
			largest = left
		end
		if right <= #items and items[right].key > items[largest].key then
			largest = right
		end
		if largest == i then
			break
		end
		items[i], items[largest] = items[largest], items[i]
		i = largest
	end
	return top.key, top.value
end

function MaxHeap:isEmpty()
	return #self.items == 0
end

local function farthestPointSampling(
	width: number,
	height: number,
	radius: number,
	initialPoints: { Vector2 }?,
	numPoints: number
): { Vector2 }
	local points = initialPoints or {}
	local gridSize = radius / math.sqrt(2)
	local grid = {}

	-- helper: grid cell index
	local function cellIndex(p: Vector2): (number, number)
		return math.floor(p.X / gridSize), math.floor(p.Y / gridSize)
	end

	-- helper: min distance to existing points
	local function minDistToNeighbors(p: Vector2): number
		local ix, iy = cellIndex(p)
		local minDist = math.huge
		for dx = -2, 2 do
			for dy = -2, 2 do
				local gx = ix + dx
				local gy = iy + dy
				if grid[gx] and grid[gx][gy] then
					for _, gpoint in ipairs(grid[gx][gy]) do
						local d = (gpoint - p).Magnitude
						if d < minDist then
							minDist = d
						end
					end
				end
			end
		end
		return minDist
	end

	-- insert a point into grid
	local function insertIntoGrid(p: Vector2)
		local ix, iy = cellIndex(p)
		grid[ix] = grid[ix] or {}
		grid[ix][iy] = grid[ix][iy] or {}
		table.insert(grid[ix][iy], p)
	end

	local function insertPoint(p: Vector2)
		table.insert(points, p)
		insertIntoGrid(p)
	end

	for _, p in ipairs(points) do
		insertIntoGrid(p)
	end

	local heap: MaxHeap<Vector2> = MaxHeap.new()
	local candidateSpacing = radius / 1.5

	for x = 0, math.floor(width / candidateSpacing) do
		for y = 0, math.floor(height / candidateSpacing) do
			local candidate = Vector2.new(
				x * candidateSpacing + Random:NextNumber() * candidateSpacing,
				y * candidateSpacing + Random:NextNumber() * candidateSpacing
			)
			local dist = minDistToNeighbors(candidate)
			heap:push(dist, candidate)
		end
	end

	while not heap:isEmpty() and #points < numPoints do
		local _, cand = heap:pop()
		if not cand then
			continue
		end
		local dist = minDistToNeighbors(cand)
		if dist >= radius then
			insertPoint(cand)
		end
	end

	return points
end

-------------------------------
-- PRIVATE HELPERS
-------------------------------

function NodeGenerator:_getNodeAmount(): number
	return NodeGenerator.areaHeight * NodeGenerator.areaWidth / (NodeGenerator.minSpacing * NodeGenerator.minSpacing)
end

function NodeGenerator:_addPoint(): Node?
	local candidates =
		farthestPointSampling(self.areaWidth, self.areaHeight, self.minSpacing, NodePoints, #NodePoints + 1)
	local newPoint: Vector2?

	for _, p in ipairs(candidates) do
		local tooClose = false
		for _, q in ipairs(NodePoints) do
			if (p - q).Magnitude < self.minSpacing then
				tooClose = true
				break
			end
		end
		if not tooClose then
			newPoint = p
			break
		end
	end

	if newPoint then
		table.insert(NodePoints, newPoint)
		local node: Node = {
			id = HttpService:GenerateGUID(false),
			position = newPoint,
		}
		table.insert(NodeState, node)
		return node
	end

	return nil
end

function NodeGenerator:_startRegen()
	if RegenActive then
		return
	end
	RegenActive = true

	task.spawn(function()
		while #NodeState < NodeGenerator:_getNodeAmount() do
			task.wait(Random:NextNumber(NodeGenerator.regenMinDelay, NodeGenerator.regenMaxDelay))
			NodeGenerator:_addPoint()
		end
		RegenActive = false
	end)
end

-------------------------------
-- PUBLIC API
-------------------------------

function NodeGenerator:generate()
	NodeState = {}
	NodePoints = {}

	local newPoints =
		farthestPointSampling(self.areaWidth, self.areaHeight, self.minSpacing, nil, NodeGenerator:_getNodeAmount())

	for _, newPoint in ipairs(newPoints) do
		table.insert(NodePoints, newPoint)
		local node: Node = {
			id = HttpService:GenerateGUID(false),
			position = newPoint,
		}
		table.insert(NodeState, node)
	end
end

function NodeGenerator:removeNode(id: string)
	local index: number?
	for i, node in ipairs(NodeState) do
		if node.id == id then
			index = i
			break
		end
	end

	if index then
		table.remove(NodeState, index)
		table.remove(NodePoints, index)

		NodeGenerator:_startRegen()
	end
end

function NodeGenerator:getNodes(): { Node }
	return table.clone(NodeState)
end

function NodeGenerator:getNode(id: string): Node?
	for _, node in ipairs(NodeState) do
		if node.id == id then
			return node
		end
	end

	return nil
end

function NodeGenerator:cleanup()
	NodeState = {}
	NodePoints = {}
	RegenActive = false
end

function NodeGenerator:visualize(parent: Instance)
	assert(parent, "Parent can't be nil!")

	for _, c in parent:GetChildren() do
		c:Destroy()
	end

	for _, node in ipairs(NodeState) do
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.Transparency = 0.5
		part.Size = Vector3.new(0.5, 0.5, 0.5)
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Position = Vector3.new(node.position.X, 0, node.position.Y)
		part.Name = node.id
		part.Parent = parent
	end
end

function NodeGenerator:setMinSpacing(minSpacing: number)
	self.minSpacing = minSpacing
end

return NodeGenerator
