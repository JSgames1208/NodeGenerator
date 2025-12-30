local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)

local e: typeof(React.createElement) = React.createElement

export type Props = UiTypes.ImageLabelProps

local function ImageLabel(props: Props)
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.BorderSizePixel = props.BorderSizePixel or 0
	props.Size = props.Size or UDim2.new(1, 0, 1, 0)
	props.Position = props.Position or UDim2.new(0, 0, 0, 0)
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY
	props.ZIndex = props.ZIndex or 1
	props.Mirror = props.Mirror or false
	props.ClipsDescendants = props.ClipsDescendants or false
	props.ImageRectOffset = props.ImageRectOffset or Vector2.zero
	props.ImageRectSize = props.ImageRectSize or Vector2.zero
	props.Children = props.Children or {} :: { React.Element<any> }

	local safeProps = Sift.Dictionary.removeKeys(props, "Children", "Mirror")

	if props.Mirror then
		-- Mirror image (flipped vertically)

		if not props.ImageRectOffset or not props.ImageRectSize then
			warn("Mirror requires ImageRectOffset and ImageRectSize")
			return nil
		end

		local mirror = e("ImageLabel", {
			Image = props.Image,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.8, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			ImageRectOffset = Vector2.new(0, props.ImageRectSize.Y),
			ImageRectSize = Vector2.new(props.ImageRectSize.X, -props.ImageRectSize.Y),
			ZIndex = (props.ZIndex or 0) - 1,
			ScaleType = props.ScaleType,
		}, {
			-- Use a UIGradient to fade out the reflection
			e("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.6),
					NumberSequenceKeypoint.new(0.3, 1),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		})

		table.insert(props.Children :: any, mirror)
	end

	return e("ImageLabel", safeProps, props.Children)
end

return ImageLabel
