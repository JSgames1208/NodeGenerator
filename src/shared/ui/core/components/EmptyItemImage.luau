local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local e: typeof(React.createElement) = React.createElement

local function EmptyItemImage(props: ItemImage.ItemImageProps)
	props.equipped = false
	props.itemId = ""
	return e(ItemImage, props)
end

return EmptyItemImage
