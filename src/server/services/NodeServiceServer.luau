--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local NodeGenerator = require(ReplicatedStorage.Shared.modules.NodeGenerator)

local NodeServiceServer = {}

function NodeServiceServer.init(self: NodeServiceServer): ()
	self.networker = Networker.server.new("NodeService", self, {
		self.generate :: any,
		self.cleanup :: any,
	})
end

function NodeServiceServer.generate(self: NodeServiceServer, _player: Player, minSpacing: number): ()
	NodeGenerator:setMinSpacing(minSpacing)
	NodeGenerator:generate()

	NodeGenerator:visualize(workspace.NodeFolder)
end

function NodeServiceServer.cleanup(self: NodeServiceServer, _player: Player): ()
	NodeGenerator:cleanup()
	NodeGenerator:visualize(workspace.NodeFolder)
end

export type NodeServiceServer = typeof(NodeServiceServer) & {
	networker: Networker.Server,
}

return NodeServiceServer :: NodeServiceServer
