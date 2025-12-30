--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local nodeSlice = require(ReplicatedStorage.Shared.ui.features.node.state.nodeSlice)

local NodeServiceClient = {}

function NodeServiceClient.init(self: NodeServiceClient): ()
	self.networker = Networker.client.new("NodeService", self)

	nodeSlice.signals.generate:Connect(function()
		local width = nodeSlice.states.currentWidth()
		local height = nodeSlice.states.currentHeight()

		self:generate(width, height)
	end)

	nodeSlice.signals.cleanup:Connect(function()
		self:cleanup()
	end)
end

function NodeServiceClient.generate(self: NodeServiceClient, width: number, height: number): ()
	self.networker:fire("generate", width, height)
end

function NodeServiceClient.cleanup(self: NodeServiceClient): ()
	self.networker:fire("cleanup")
end

export type NodeServiceClient = typeof(NodeServiceClient) & {
	networker: Networker.Client,
}

return NodeServiceClient :: NodeServiceClient
