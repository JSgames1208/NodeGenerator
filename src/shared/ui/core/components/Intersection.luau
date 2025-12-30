local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e: typeof(React.createElement) = React.createElement

export type IntersectionProps = {
	LayoutOrder: number?,
	ZIndex: number?,
	shown: boolean?,
}

--[[local ColorSequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.1, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(220, 220, 220)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(220, 220, 220)),
	ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})]]

local TransparencySequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.1, 1),
	NumberSequenceKeypoint.new(0.3, 0),
	NumberSequenceKeypoint.new(0.7, 0),
	NumberSequenceKeypoint.new(0.9, 1),
	NumberSequenceKeypoint.new(1, 1),
})

local function Intersection(props: IntersectionProps)
	return e("Frame", {
		Visible = props.shown ~= nil and props.shown,
		Size = UDim2.new(1, 0, 0, 3),
		LayoutOrder = props.LayoutOrder or nil,
		BackgroundColor3 = Color3.fromRGB(220, 220, 220),
		ZIndex = props.ZIndex or 0,
		BorderSizePixel = 0,
	}, {
		e("UIGradient", {
			Transparency = TransparencySequence,
			Rotation = 0,
		}),
	})
end

return Intersection
