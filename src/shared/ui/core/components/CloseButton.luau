local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)

export type Props = {
	onClick: () -> (),
}

local function CloseButton(props: Props)
	return React.createElement(Button, {
		ClipsDescendants = false,
		Size = UDim2.new(0.1, 0, 0.1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Position = UDim2.new(1, 0, 0, 0),
		AnchorPoint = Vector2.new(0.8, 0.2),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		onClick = props.onClick,
		Children = {
			React.createElement("UIStroke", {
				Color = Color3.fromRGB(200, 0, 0),
				Thickness = 7,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
			React.createElement("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
			React.createElement(TextLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 0),
				Children = {},
				Text = "X",
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Stroke = {
					Color = Color3.fromRGB(200, 200, 200),
					Thickness = 5,
				},
			}),
		},
	})
end

return CloseButton
