local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local ScrollingItemLayout = require(ReplicatedStorage.Shared.ui.features.inventory.components.ScrollingItemLayout)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local e: typeof(React.createElement) = React.createElement

export type SelectItemMenuProps = {
	clickCallback: (any) -> any,
	setOpen: ((any) -> any)?,
	items: { { id: string, atom: Charm.Atom<DataTemplate.InventoryEntry> } },
	menuTitle: string?,
	shown: boolean,
	showAmount: boolean?,
	changeEquipped: boolean?,
}

local function SelectItemMenu(props: SelectItemMenuProps)
	local equippedToolGuid = ReactCharm.useAtom(toolSlice.states.equipped)

	return e(MenuScreen, {
		addCloseButton = true,
		shown = props.shown,
		menuTitle = props.menuTitle or "Select Item!",
		setOpen = props.setOpen,
		children = {
			e(ScrollingItemLayout, {
				items = props.items,
				tab = props.showAmount and "item" or "tool",
				setOpen = props.setOpen,
				equippedToolId = props.changeEquipped and equippedToolGuid or "",
				clickCallback = props.clickCallback,
				exitOnPress = true,
			}),
		},
	})
end

return SelectItemMenu
