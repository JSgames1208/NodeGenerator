local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local LeftMenu = require(ReplicatedStorage.Shared.ui.features.node.components.LeftMenu)
local e: typeof(React.createElement) = React.createElement

return function()
	return e(React.Fragment, nil, {
		e(LeftMenu),
	})
end
