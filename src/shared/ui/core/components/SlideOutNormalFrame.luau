local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local useSpring = require(ReplicatedStorage.Shared.ui.core.hooks.useSpring)

export type Props = {
	Size: UDim2,
	Shown: boolean,
	From: UDim2,
	To: UDim2,
	Speed: number?,
	Rotation: UDim2?,
	AnchorPoint: Vector2?,
	BackgroundTransparency: number?,
	BackgroundColor3: Color3?,
	ZIndex: number?,
	children: { React.ReactElement<any> },
}

local CUSTOM_SLIDE_OUT_PROPS = { "Shown", "From", "To", "Duration", "children", "Speed" }

return React.forwardRef(function(props: Props, ref)
	local shown = props.Shown
	local speed = props.Speed or 20
	local from, to = props.From, props.To
	local mounted, setMounted = React.useState(shown)

	local posSpring = useSpring(if shown then from else to, { speed = speed })
	local safeProps = Sift.Dictionary.removeKeys(props, unpack(CUSTOM_SLIDE_OUT_PROPS))
	safeProps.ref = ref
	safeProps.Position = posSpring.binding

	React.useEffect(function()
		if shown then
			return
		end

		posSpring.setGoal(to)

		local discon = posSpring.onComplete(function()
			if not shown then
				setMounted(false)
			end
		end)

		return discon
	end, { shown, to })

	React.useEffect(function()
		if not shown then
			return
		end

		if not mounted then
			setMounted(true)
			return
		end

		posSpring.snap(to)
		posSpring.setGoal(from)
	end, { shown, mounted, from, to })

	if not mounted then
		return nil
	end

	return React.createElement("Frame", safeProps, { unpack(props.children) })
end)
