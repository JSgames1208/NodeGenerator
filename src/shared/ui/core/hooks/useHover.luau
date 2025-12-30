local React = require(game.ReplicatedStorage.Packages.React)

local function useHover()
	local isHovered, setHovered = React.useState(false)

	local function onMouseEnter()
		setHovered(true)
	end

	local function onMouseLeave()
		setHovered(false)
	end

	return isHovered, {
		["onMouseEnter"] = onMouseEnter,
		["onMouseLeave"] = onMouseLeave,
	}
end

return useHover
