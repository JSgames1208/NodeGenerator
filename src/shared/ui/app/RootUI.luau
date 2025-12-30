local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local MazeScreen = require(ReplicatedStorage.Shared.ui.features.maze.screens.MazeScreen)
local e: typeof(React.createElement) = React.createElement

local function RootUI()
	return e(React.Fragment, nil, {
		App = e("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
		}, {
			e(MazeScreen),
		}),
	})
end

return RootUI
