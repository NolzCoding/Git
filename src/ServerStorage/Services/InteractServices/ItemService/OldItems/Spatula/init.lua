local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
local SpatulaServer = {};
local SpatulaServerClass = {metatable = {__index = SpatulaServer}};
export type SpatulaServer = {
	ClassName: "SpatulaServer";

	Destroy: (self: SpatulaServer) -> ();
    Parent: Tool;
};
type _SpatulaServer = SpatulaServer & {

    _Activated: (self: SpatulaServer) -> ();
    _Connections: {RBXScriptConnection};
    _RemoteEvent: RemoteEvent;
    _Player: Player;
    _Character: Model;
    _HumanoidRootPart: Part;

};

SpatulaServer.ClassName = "SpatulaServer";

function SpatulaServer.Destroy(self: _SpatulaServer): ()
	--TODO: Implement me
end

local CASTSIZE = Vector3.new(2, 10, 2);


function SpatulaServer._Activated(self: _SpatulaServer)

    local params = RaycastParams.new();
    params.FilterDescendantsInstances = {self._Character};
    params.FilterType = Enum.RaycastFilterType.Blacklist;

    local result = Workspace:Blockcast(self._HumanoidRootPart.CFrame + Vector3.new(0,0,0), CASTSIZE, self._HumanoidRootPart.CFrame.LookVector * 20, params);

    if not result then
        return
    end

    local humanoid = result.Instance.Parent:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    local victim = humanoid.Parent;
    local rootpart : Part = victim:FindFirstChild("HumanoidRootPart");
    humanoid:TakeDamage(25)


    --rootpart:SetNetworkOwner(self._Player);



end



function SpatulaServerClass.new(parent : Tool, player : Player): SpatulaServer
	local self: _SpatulaServer = setmetatable({}, SpatulaServerClass.metatable) :: any;
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

return SpatulaServerClass;
