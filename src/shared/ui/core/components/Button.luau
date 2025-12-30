local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local UiTypes = require(ReplicatedStorage.Shared.ui.core.UiTypes)
local useHover = require(ReplicatedStorage.Shared.ui.core.hooks.useHover)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)

local e = React.createElement

local DEFAULT_HOVER_SCALE = 1.15

export type ButtonProps = UiTypes.ImageLabelProps & {
	hoverScale: number?,
	Mirror: boolean,
	Children: { React.Element<any> },
	onClick: (any?) -> any?,
	onHover: (any?) -> any?,
	onHoverEnded: (any?) -> any?,
	spring: boolean?,
}

local Button = React.forwardRef(function(props: ButtonProps, ref: React.Ref<GuiObject?>)
	local hoverScale = props.hoverScale or DEFAULT_HOVER_SCALE
	local isHovering, hoverEvents = useHover()
	local spring = useSpring(1, { speed = 12.5 })

	props.spring = (props.spring == nil) and true or props.spring

	React.useEffect(function()
		if props.spring then
			spring.setGoal(1)
		end
	end, { props.LayoutOrder })

	-- Hover animation (ignored when layout changes)
	React.useEffect(function()
		if not props.spring then
			return
		end

		if isHovering then
			if props.onHover and type(props.onHover) == "function" then
				props.onHover()
			end
			spring.setGoal(hoverScale)
		else
			if props.onHoverEnded and type(props.onHoverEnded) == "function" then
				props.onHoverEnded()
			end
			spring.setGoal(1)
		end
	end, { isHovering, hoverScale })

	-- preserve onClick if provided
	if props.onClick then
		props[React.Event.MouseButton1Click] = props.onClick
		props[React.Event.TouchTap] = props.onClick
	end

	local safeProps = Sift.Dictionary.removeKeys(
		props,
		"Children",
		"Mirror",
		"hoverScale",
		"onClick",
		"onHover",
		"onHoverEnded",
		"spring",
		"springTrigger"
	)

	local buttonProps = Sift.Dictionary.join(safeProps, {
		[React.Event.MouseEnter] = hoverEvents.onMouseEnter,
		[React.Event.MouseLeave] = hoverEvents.onMouseLeave,
		ref = ref,
	})

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

	return e("ImageButton", buttonProps, {
		props.Children,
		e("UIScale", {
			Scale = spring.binding,
		}),
	})
end)

return Button
