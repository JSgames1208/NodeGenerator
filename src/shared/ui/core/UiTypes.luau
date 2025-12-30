local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

export type TextLabelProps = {
	Children: { React.ReactElement<any> },
	Text: string,
	TextColor3: (Color3 | ColorSequence)?,
	TextSize: number?,
	TextScaled: boolean?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
	BackgroundTransparency: number?,
	BorderSizePixel: number?,
	Size: UDim2,
	Position: UDim2,
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	Font: Enum.Font?,
	ZIndex: number?,
	Prefix: {
		Image: string,
		Offset: number,
		ImageRectOffset: Vector2?,
		ImageRectSize: Vector2?,
		Size: UDim2,
		Mirror: boolean?,
	}?,
	Stroke: {
		Color: Color3?,
		Thickness: number?,
	}?,
}

export type ImageLabelProps = {
	Image: string,
	BackgroundTransparency: number?,
	BorderSizePixel: number?,
	Size: UDim2,
	Position: UDim2,
	AnchorPoint: Vector2?,
	ScaleType: Enum.ScaleType?,
	TileSize: UDim2?,
	BackgroundColor3: Color3?,
	SizeConstraint: Enum.SizeConstraint?,
	ClipsDescendants: boolean?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,
	Mirror: boolean?,
	ZIndex: number?,
	LayoutOrder: number?,
	Children: { React.Element<any> }?,
}

export type ButtonProps = ImageLabelProps & {
	hoverScale: number,
	onClick: (any?) -> any?,
}

return {}
