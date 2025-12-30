local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local RarityColors = require(ReplicatedStorage.Shared.modules.core.RarityColors)
local Items = require(ReplicatedStorage.Shared.modules.core.registries.Items)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)
local e: typeof(React.createElement) = React.createElement

type ItemData = ItemType.ItemData

export type ItemImageProps = {
	itemId: string,
	equipped: boolean?,
	Size: UDim2?,
	SizeConstraint: Enum.SizeConstraint?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	children: { React.ReactElement<any> }?,
}

-- Item image, with background, image, and rarity color. Optionally equipped
local function ItemImage(props: ItemImageProps)
	local imageColor = Color3.fromRGB(210, 210, 210)

	local itemEntry = Items.get(props.itemId)
	if not itemEntry then
		itemEntry = Items.DIRT
	end
	local isTool = itemEntry.toolStats ~= nil

	props.equipped = props.equipped ~= nil and props.equipped or false

	if isTool and props.equipped then
		imageColor = Color3.fromRGB(0, 230, 0)
	else
		if itemEntry then
			imageColor = RarityColors[itemEntry.rarity]
		else
			imageColor = RarityColors.fallback
		end
	end

	return e(ImageLabel, {
		Image = ImageIds.icons[props.itemId] or ImageIds.icons["placeholder"],
		BackgroundTransparency = 1,
		Size = props.Size or UDim2.new(1, 0, 1, 0),
		SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXX,
		Position = props.Position or UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		ZIndex = 3,
		ScaleType = Enum.ScaleType.Crop,
		Children = {
			e("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
			e(ImageLabel, {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = ImageIds.icons.button_background,
				ImageColor3 = imageColor,
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				ZIndex = 1,
			}),
			table.unpack(props.children or {}),
		},
	})
end

return ItemImage
