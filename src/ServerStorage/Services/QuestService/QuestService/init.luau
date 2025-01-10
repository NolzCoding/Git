local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local QuestService = Knit.CreateService {
    Name = "QuestService",
    Client = {}
}

function QuestService:KnitInit()

end

local templates = {
    {
        Action = "Battery",
        Range = {2, 8},
        Name = "Eat %i Batteries",
        Award = "Cash",
        Args = {100}
    },

    {
        Action = "BabyPickup",
        Range = {2, 8},
        Name = "Pickup %i Babies",
        Award = "Cash",
        Args = {100}
    },

    {
        Action = "Damage",
        Range = {100, 500},
        Name = "Take %i Damage",
        Award = "Cash",
        Args = {150}
    },

}

function QuestService:NewRandomDailyQuests()
    local quests = {}

    local randomIndex = math.random(1, #templates) -- go -1 0 and +1 from this index to get 3 random quests

    for i = -1, 1 do
        -- make sure the index is in bounds
        local index = randomIndex + i
        if index < 1 then
            index = #templates
        elseif index > #templates then
            index = 1
        end

        local template = templates[index]

        local goal = math.round(math.random(template.Range[1], template.Range[2]))

        local quest = {
            Name = string.format(template.Name, goal),

            Goal = goal,
            Points = 0,
            Claimed = false,
            Action = template.Action,
            Award = template.Award,
            Args = template.Args
        }
        table.insert(quests, quest)
    end
    return quests
end

function QuestService:PerformedAction(player : Player, actionName : string, amount : number)
    local data = self.DataService:GetData(player)

    for _, quest in ipairs(data.Quests.DailyQuests) do
        if quest.Action == actionName then
            quest.Points += amount
        end
    end

    self.DataService:SetData(player, "Quests", data.Quests)

end

function QuestService:NewDailyQuests (player : Player)
    local data = self.DataService:GetData(player)
    data.Quests.DailyQuests = self:NewRandomDailyQuests()
    self.DataService:SetData(player, "Quests", data.Quests)
end

function QuestService:Claim(player : Player, index : number)
    local data = self.DataService:GetData(player)
    local quest = data.Quests.DailyQuests[index]
    -- remove quest
    table.remove(data.Quests.DailyQuests, index)
    self.DataService:SetData(player, "Quests", data.Quests)
    self.AwardService:GiveAward(player, quest.Award, unpack(quest.Args))
end

function QuestService.Client:Claim(player, index)
    return self.Server:Claim(player, index)
end

function QuestService:KnitStart()

    self.DataService = Knit.GetService("DataService")
    self.AwardService = Knit.GetService("AwardService")

    while true do

        task.spawn(function()
            -- check if it's a new day
            for _,v in ipairs(game.Players:GetPlayers()) do
                local data = self.DataService:GetData(v)
                local timeElapsed = DateTime.now().UnixTimestamp - data.Quests.LastDailyQuest

                if timeElapsed >= 86400 then
                    data.Quests.LastDailyQuest = DateTime.now().UnixTimestamp -- for testing purposes
                    self:NewDailyQuests(v)
                end

            end
        end)

        task.wait(1)

    end

    game.Players.PlayerAdded:Connect(function(player)
        self:NewDailyQuests(player)
    end)

end


return QuestService