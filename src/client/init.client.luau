local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local NodeServiceClient = require(ReplicatedStorage.Shared.services.NodeServiceClient)
local RootUI = require(ReplicatedStorage.Shared.ui.app.RootUI)
local player = Players.LocalPlayer

NodeServiceClient:init()

local function setupUI()
	local playerGui = player:WaitForChild("PlayerGui")

	-- Clear any old ReactUI folder if it exists
	local existingFolder = playerGui:FindFirstChild("ReactUI")
	if existingFolder then
		existingFolder:Destroy()
	end

	local uiFolder = Instance.new("Folder")
	uiFolder.Name = "ReactUI"
	uiFolder.Parent = playerGui

	local root = ReactRoblox.createRoot(uiFolder)
	root:render(React.createElement(RootUI))
end

-- Initial UI setup
setupUI()

-- Re-setup UI on respawn
player.CharacterAdded:Connect(function()
	setupUI()
end)
