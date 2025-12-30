local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local e: typeof(React.createElement) = React.createElement

export type ThemedFrameProps = {
	shown: boolean,
	Size: UDim2,
	From: UDim2,
	To: UDim2,
	Speed: number,
	AnchorPoint: Vector2?,
	children: { React.ReactElement<any> },
}

local function ThemedFrame(props: ThemedFrameProps)
	return e(SlideOutFrame, {
		Shown = props.shown,
		Size = props.Size,
		From = props.From,
		To = props.To,
		Speed = props.Speed,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(245, 245, 245),
		children = {
			e("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = 10,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
			e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			props.children,
		},
	})
end

return ThemedFrame
