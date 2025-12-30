local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ThemedFrame = require(ReplicatedStorage.Shared.ui.core.components.ThemedFrame)
local e: typeof(React.createElement) = React.createElement

export type MenuScreenProps = {
	shown: boolean,
	menuTitle: string,
	setOpen: (any) -> any?,
	children: { React.ReactElement<any> },
	addCloseButton: boolean?,
}

local function MenuScreen(props: MenuScreenProps)
	if props.addCloseButton == nil then
		props.addCloseButton = true
	end

	local closeButton = nil

	if props.addCloseButton then
		closeButton = e(Button, {
			Size = UDim2.new(0.1, 0, 0.1, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(0.8, 0.2),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(225, 0, 0),
			onClick = function()
				props.setOpen(false)
			end,
			ZIndex = 6,
			Children = {
				e(TextLabel, {
					Text = "X",
					Font = Enum.Font.FredokaOne,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0.8, 0, 0.8, 0),
					TextScaled = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					ZIndex = 10,
					Children = {},
				}),
				e("UICorner", {
					CornerRadius = UDim.new(0.2, 0),
				}),
				e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 10,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}),
			},
		})
	end

	return e(
		ThemedFrame,
		{
			shown = props.shown,
			Size = UDim2.new(0, 2000, 0, 1500),
			From = UDim2.new(0.5, 0, 0.5, 0),
			To = UDim2.new(0.5, 0, -0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Speed = 10,
			children = {
				e(TextLabel, {
					Text = props.menuTitle,
					Font = Enum.Font.FredokaOne,
					Position = UDim2.new(0.05, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0.75),
					Size = UDim2.new(0.5, 0, 0.1, 0),
					TextScaled = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Children = {},
					TextColor3 = Color3.fromRGB(255, 255, 255),
					ZIndex = 5,
					Stroke = {
						Thickness = 10,
						Color = Color3.fromRGB(0, 0, 0),
					},
				}),
				closeButton,
				table.unpack(props.children),
			},
		} :: ThemedFrame.ThemedFrameProps
	)
end

return MenuScreen
