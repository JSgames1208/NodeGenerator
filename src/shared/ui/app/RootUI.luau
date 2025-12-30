local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local NodeScreen = require(ReplicatedStorage.Shared.ui.features.node.screens.NodeScreen)
local e: typeof(React.createElement) = React.createElement

local function RootUI()
	return e(React.Fragment, nil, {
		App = e("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
		}, {
			e(NodeScreen),
		}),
	})
end

return RootUI
