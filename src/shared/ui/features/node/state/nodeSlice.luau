local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Signal = require(ReplicatedStorage.Packages.Signal)
local atom: typeof(Charm.atom) = Charm.atom
type Atom<T> = Charm.Atom<T>

local currentWidth: Atom<number> = atom(10)
local currentHeight: Atom<number> = atom(10)

local signals = {
	generate = Signal.new(),
	cleanup = Signal.new(),
}

local actions = {
	setWidth = function(width: number)
		currentWidth(tonumber(width))
	end,
	setHeight = function(height: number)
		currentHeight(tonumber(height))
	end,
}

return {
	states = {
		currentWidth = currentWidth,
		currentHeight = currentHeight,
	},
	signals = signals,
	actions = actions,
}
