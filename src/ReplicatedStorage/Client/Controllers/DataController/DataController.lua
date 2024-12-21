
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local DataController = Knit.CreateController{Name = "DataController"}

function DataController:KnitInit()
    self.CashFunctions = {}
    self.DataChanged = {}

end

function DataController:KnitStart()
    self.DataService = Knit.GetService("DataService")
    local success, data = self.DataService.DataProperty:OnReady():await()
    self.DataService.DataSetSignal:Connect(function(DataName, data)


        if self.DataChanged[DataName] then

            for _, func in ipairs(self.DataChanged[DataName]) do

                func(data)

            end

        end


    end)




end

function DataController:OnCashChanged(func: () -> () )

    table.insert(self.CashFunctions, func)

end

function DataController:OnDataChanged(DataName, func: () -> () )

    if self.DataChanged[DataName] then

        table.insert(self.DataChanged[DataName], func)

    else

        self.DataChanged[DataName] = {func}

    end


end




-- srry i couldnt find where your declarations and/or definitions were at

return DataController



