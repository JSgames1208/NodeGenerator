local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local ToolUtil = require(ReplicatedStorage.Shared.services.ToolService.util.ToolUtil)
local InventoryTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.InventoryTooltip)
local ToolTooltip = require(ReplicatedStorage.Shared.ui.features.inventory.components.ToolTooltip)
local tooltipSlice = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipSlice)
local tooltipThunk = require(ReplicatedStorage.Shared.ui.features.inventory.state.tooltipThunk)

local e: typeof(React.createElement) = React.createElement

local function TooltipProvider()
	local tooltipAtom = ReactCharm.useAtom(tooltipSlice.states.tooltip)

	if not tooltipAtom.shown or not tooltipAtom.anchor or not tooltipAtom.anchor.current then
		return nil
	end

	local toolInstance: ToolUtil.ToolInstance = tooltipThunk.actions.getToolInstance(tooltipAtom.guid)

	if tooltipAtom.type == "tool" then
		return e(ToolTooltip, {
			shown = tooltipAtom.shown,
			anchor = tooltipAtom.anchor,
			title = tooltipAtom.title,
			description = tooltipAtom.description,
			toolInstance = toolInstance,
		})
	else
		return e(InventoryTooltip, {
			shown = tooltipAtom.shown,
			anchor = tooltipAtom.anchor,
			title = tooltipAtom.title,
			description = tooltipAtom.description,
			children = {},
		})
	end
end

return TooltipProvider
