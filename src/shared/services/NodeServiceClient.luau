--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local nodeSlice = require(ReplicatedStorage.Shared.ui.features.node.state.nodeSlice)

local NodeServiceClient = {}

function NodeServiceClient.init(self: NodeServiceClient): ()
	self.networker = Networker.client.new("NodeService", self)

	nodeSlice.signals.generate:Connect(function()
		local minSpacing = nodeSlice.states.minSpacing()

		print(minSpacing)

		self:generate(minSpacing)
	end)

	nodeSlice.signals.cleanup:Connect(function()
		self:cleanup()
	end)
end

function NodeServiceClient.generate(self: NodeServiceClient, minSpacing: number): ()
	self.networker:fire("generate", minSpacing)
end

function NodeServiceClient.cleanup(self: NodeServiceClient): ()
	self.networker:fire("cleanup")
end

export type NodeServiceClient = typeof(NodeServiceClient) & {
	networker: Networker.Client,
}

return NodeServiceClient :: NodeServiceClient
