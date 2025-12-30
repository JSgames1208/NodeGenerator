local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SelectItemMenu = require(ReplicatedStorage.Shared.ui.core.components.SelectItemMenu)
local inventorySlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.inventorySlice)
local toolSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.toolSlice)
local e: typeof(React.createElement) = React.createElement

export type SwapToolMenuProps = {
	clickCallback: (any) -> any,
	setOpen: ((any) -> any)?,
	menuTitle: string?,
	shown: boolean,
}

local function SwapToolMenu(props: SwapToolMenuProps)
	local equippedToolId = ReactCharm.useAtom(toolSlice.states.equipped)

	local inventory = ReactCharm.useAtom(inventorySlice.states.inventory)

	local categoryMap = inventory["tool"]

	local items = {}

	for id, entryAtom in categoryMap do
		table.insert(items, { id = id, atom = entryAtom })
	end

	table.sort(items, function(a, b)
		local aEntry = a.atom()
		local bEntry = b.atom()

		-- equipped tool goes first
		local aIsEquipped = aEntry.guid == equippedToolId
		local bIsEquipped = bEntry.guid == equippedToolId

		if aIsEquipped and not bIsEquipped then
			return true
		end
		if bIsEquipped and not aIsEquipped then
			return false
		end

		-- otherwise alphabetical
		return aEntry.id < bEntry.id
	end)

	return e(SelectItemMenu, {
		shown = props.shown,
		menuTitle = props.menuTitle or "Select Tool!",
		setOpen = props.setOpen,
		items = items,
		clickCallback = props.clickCallback,
		changeEquipped = true,
	})
end

return SwapToolMenu
