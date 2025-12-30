local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ItemImage = require(ReplicatedStorage.Shared.ui.core.components.ItemImage)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local e: typeof(React.createElement) = React.createElement

export type ItemWithAmountProps = {
	itemId: string,
	amount: number,
	equipped: boolean?,
}

local function ItemWithAmount(props: ItemWithAmountProps)
	return e(ItemImage, {
		itemId = props.itemId,
		equipped = props.equipped,
		children = {
			e(
				TextLabel,
				{
					Text = props.amount .. "x",
					Size = UDim2.new(1, 0, 0.4, 0),
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(0.85, 0.5),
					TextXAlignment = Enum.TextXAlignment.Right,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					TextScaled = true,
					TextWrapped = true,
					ZIndex = 3,
					Stroke = {
						Thickness = 7.5,
						Color = Color3.fromRGB(30, 30, 30),
					},
				} :: TextLabel.Props
			),
		},
	})
end

return ItemWithAmount
