local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local BattlepassInfo = require(ReplicatedStorage.Source.Shared.Battlepass)
local BattlepassService = Knit.CreateService {
    Name = "BattlepassService";
    Client = {};
}

type Pass = {
    Name : string,
    Claimed : {boolean},
    Exp : number,
}

function BattlepassService:KnitStart()

    self.DataService = Knit.GetService("DataService")
    self.LevelService = Knit.GetService("LevelService")
    local startPass = "FreePassS1"
    self.AwardService = Knit.GetService("AwardService")
    self.DataService:ListenForJoin(function(player, profile)

        local data = profile.Data.Battlepass.Passes

        -- add the battlepass to the player's data if it doesn't exist

        if not data[startPass] then

            -- new battlepass
            data[startPass] = {
                Name = startPass,
                Claimed = {} :: {boolean},
                Exp = 0,
            } :: Pass

            -- set the data
            self.DataService:SetData(player, "Battlepass", profile.Data.Battlepass)

        end

    end)

    self.LevelService.PlayerGotExperience:Connect(function(player : Player, amount : number)

        -- get all passes

        local data = self.DataService:GetData(player)

        for name, pass in pairs(data.Battlepass.Passes) do

            self:AddExp(player, name, amount)


        end


    end)

end

function BattlepassService:Claim(player : Player, name : string, index : number)

    print("test")

    -- check if the player has the battlepass
    local data = self.DataService:GetData(player)
    local pass = data.Battlepass.Passes[name] :: Pass?

    if not pass then
        return
    end

    -- check if the player has already claimed the reward

    if pass.Claimed[index] then
        return
    end

    -- check if the player has enough exp to claim the reward
    local passLevel = BattlepassInfo[name][index] :: BattlepassInfo.PassLevel

    if data.Battlepass.Passes["FreePassS1"].Exp < passLevel.RequiredEXP then -- free pass for now because you want them to be able to claim the premium pass rewards with the free pass exp
        return
    end

    -- claim the reward

    pass.Claimed[index] = true
    self.AwardService:GiveAward(player, passLevel.RewardType, unpack(passLevel.Args))

    -- set the data

    self.DataService:SetData(player, "Battlepass", data.Battlepass)

end

function BattlepassService:AddExp(player : Player, name : string, exp : number)

    -- check if the player has the battlepass
    local data = self.DataService:GetData(player)
    local pass = data.Battlepass.Passes[name] :: Pass?

    if not pass then
        return
    end
    -- add the exp
    pass.Exp = pass.Exp + exp
    -- set the data
    self.DataService:SetData(player, "Battlepass", data.Battlepass)

end

function BattlepassService:AddPass(player : Player, name : string)

    -- check if the player has the battlepass
    local data = self.DataService:GetData(player)

    -- new pass
    print("Adding new pass")
    local newPass = {
        Name = name,
        Claimed = {} :: {boolean},
        Exp = 0,
    } :: Pass

    data.Battlepass.Passes[name] = newPass


    -- set the data

    self.DataService:SetData(player, "Battlepass", data.Battlepass)

end

function BattlepassService:KnitInit()
end

function BattlepassService.Client:Claim(player : Player, name : string, index : number)

    return self.Server:Claim(player, name, index)

end

return BattlepassService