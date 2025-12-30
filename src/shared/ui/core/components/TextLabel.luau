local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)
local ImageLabel = require(ReplicatedStorage.Shared.ui.core.components.ImageLabel)

local e = React.createElement

export type Props = UiTypes.TextLabelProps

local function TextLabel(props: Props)
	props.Children = props.Children or {}
	props.TextSize = props.TextSize or 14
	props.TextScaled = if props.TextScaled == nil then true else props.TextScaled
	props.TextWrapped = if props.TextWrapped == nil then false else props.TextWrapped
	props.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Top
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.BorderSizePixel = props.BorderSizePixel or 0
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.Stroke = props.Stroke or nil
	props.Prefix = props.Prefix or nil
	props.Font = props.Font or Enum.Font.FredokaOne

	local safeProps = Sift.Dictionary.removeKeys(props, "Prefix", "Stroke", "Children")

	-- Add stroke if present
	if props.Stroke then
		props.Stroke.Color = props.Stroke.Color or Color3.new(0, 0, 0)
		props.Stroke.Thickness = props.Stroke.Thickness or 1

		table.insert(
			props.Children,
			e("UIStroke", {
				Color = props.Stroke.Color,
				Thickness = props.Stroke.Thickness,
			})
		)
	end

	-- Add prefix and optional reflection
	if props.Prefix then
		local prefixImage = props.Prefix.Image
		local prefixSize = props.Prefix.Size
		local offset = props.Prefix.Offset or 0
		local mirrorEnabled = props.Prefix.Mirror or false

		local prefix = e(ImageLabel, {
			Image = prefixImage,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			ClipsDescendants = false,
			Size = prefixSize,
			Mirror = mirrorEnabled,
			ImageRectSize = props.Prefix.ImageRectSize,
			ImageRectOffset = props.Prefix.ImageRectOffset,
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = UDim2.new(0, offset, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ZIndex = 2,
		})

		table.insert(props.Children, prefix)
	end

	return e("TextLabel", safeProps, props.Children)
end

return TextLabel
