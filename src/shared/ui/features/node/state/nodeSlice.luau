local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local Signal = require(ReplicatedStorage.Packages.Signal)
local atom: typeof(Charm.atom) = Charm.atom
type Atom<T> = Charm.Atom<T>

local minSpacing: Atom<number> = atom(10)

local signals = {
	generate = Signal.new(),
	cleanup = Signal.new(),
}

local actions = {
	setMinSpacing = function(value: number)
		minSpacing(value)
	end,
}

return {
	states = {
		minSpacing = minSpacing,
	},
	signals = signals,
	actions = actions,
}
