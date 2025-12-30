local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ThemedFrame = require(ReplicatedStorage.Shared.ui.core.components.ThemedFrame)
local nodeSlice = require(ReplicatedStorage.Shared.ui.features.node.state.nodeSlice)
local e: typeof(React.createElement) = React.createElement

local function LeftMenu()
	local shown = true

	local widthRef = React.useRef(nil)
	local heightRef = React.useRef(nil)

	return e(ThemedFrame, {
		shown = shown,
		Size = UDim2.new(0, 500, 0, 800),
		From = UDim2.new(0, 30, 0.5, 0),
		To = UDim2.new(0, 30, 0.5, 0),
		Speed = 8,
		AnchorPoint = Vector2.new(0, 0.5),
		children = {
			e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 25),
			}),

			e(Button, {
				hoverScale = 1.05,
				Size = UDim2.new(0.8, 0, 0.12, 0),
				Position = UDim2.new(0.5, 0, 0.9, 0),
				AnchorPoint = Vector2.new(0.5, 0.9),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(47, 255, 0),
				onClick = function()
					nodeSlice.signals.generate:Fire()
				end,
				ZIndex = 6,
				Children = {
					e(TextLabel, {
						Text = "Generate",
						Font = Enum.Font.FredokaOne,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 7,
						Stroke = {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 5,
						},
						Children = {},
					}),
					e("UICorner", {
						CornerRadius = UDim.new(0.2, 0),
					}),
					e("UIStroke", {
						Color = Color3.fromRGB(25, 116, 0),
						Thickness = 5,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					}),
				},
			}),

			e(Button, {
				hoverScale = 1.05,
				Size = UDim2.new(0.8, 0, 0.12, 0),
				Position = UDim2.new(0.5, 0, 0.9, 0),
				AnchorPoint = Vector2.new(0.5, 0.9),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(213, 0, 0),
				onClick = function()
					nodeSlice.signals.cleanup:Fire()
				end,
				ZIndex = 6,
				Children = {
					e(TextLabel, {
						Text = "Cleanup",
						Font = Enum.Font.FredokaOne,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 7,
						Stroke = {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 5,
						},
						Children = {},
					}),
					e("UICorner", {
						CornerRadius = UDim.new(0.2, 0),
					}),
					e("UIStroke", {
						Color = Color3.fromRGB(106, 0, 0),
						Thickness = 5,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					}),
				},
			}),
		},
	})
end

return LeftMenu
