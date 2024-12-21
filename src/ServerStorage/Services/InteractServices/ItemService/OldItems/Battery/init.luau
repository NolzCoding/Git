local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
local BatteryServer = {};
local BatteryServerClass = {metatable = {__index = BatteryServer}};
export type BatteryServer = {
	ClassName: "BatteryServer";

	Destroy: (self: BatteryServer) -> ();
    Parent: Tool;
};
type _BatteryServer = BatteryServer & {

    _Activated: (self: BatteryServer) -> ();
    _Connections: {RBXScriptConnection};
    _RemoteEvent: RemoteEvent;
    _Player: Player;
    _Character: Model;
    _HumanoidRootPart: Part;

};

BatteryServer.ClassName = "BatteryServer";

function BatteryServer.Destroy(self: _BatteryServer): ()
	--TODO: Implement me

    table.clear(self._Connections);

end


function BatteryServer._Activated(self: _BatteryServer)

end



function BatteryServerClass.new(parent : Tool, player : Player): BatteryServer
	local self: _BatteryServer = setmetatable({}, BatteryServerClass.metatable) :: any;
    self.Parent = parent;

    self._Player = player
    self._Character = player.Character
    self._HumanoidRootPart = self._Character:WaitForChild("HumanoidRootPart");

    self._RemoteEvent = Instance.new("RemoteEvent");
    self._RemoteEvent.Name = "Remote";
    self._RemoteEvent.Parent = self.Parent;

    self._Connections = {}

    table.insert(self._Connections, self._RemoteEvent.OnServerEvent:Connect(function(player)

    end));

    table.insert(self._Connections, self.Parent.Activated:Connect(function()
        self:_Activated();
    end));

	return self;
end

return BatteryServerClass;
