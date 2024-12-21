local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)



local SelectionService = Knit.CreateService{
    Name = "SelectionService",
}

function SelectionService:SelectionAdded(Selection : BasePart)

    local ClickDetector : ClickDetector = Selection:FindFirstChild("ClickDetector")

    ClickDetector.MouseHoverEnter:Connect(function(plrwhoclicked)

        self:SelectionHovered(Selection , plrwhoclicked)

    end)

    ClickDetector.MouseHoverLeave:Connect(function(plrwhoclicked)

        self:SelectionUnHovered(Selection, plrwhoclicked)

    end)

    ClickDetector.MouseClick:Connect(function(plrwhoclicked)
        self:SelectionClicked(Selection, plrwhoclicked)

    end)

end

function SelectionService:SelectionClicked(Selection : BasePart, plrwhoclicked)

    local name = "Selection"

    for _, v in ipairs(Selection:GetTags()) do
        if self.Handlers[v] and v ~= "Selection" then
            name = v
            break
        end
    end



    self.Handlers[name]:Click(Selection, plrwhoclicked)


end

function SelectionService:SelectionHovered(Selection : BasePart, plrwhoclicked)


    local name = "Selection"

    for _, v in ipairs(Selection:GetTags()) do
        if self.Handlers[v] and v ~= "Selection" then
            name = v
            break
        end
    end



    self.Handlers[name]:Hover(Selection, plrwhoclicked)

end

function SelectionService:SelectionUnHovered(Selection : BasePart, plrwhoclicked)


    local name = "Selection"

    for _, v in ipairs(Selection:GetTags()) do
        if self.Handlers[v] and v ~= "Selection" then
            name = v
            break
        end
    end


    self.Handlers[name]:UnHover(Selection, plrwhoclicked)

end

function SelectionService.Client:SelectionClicked(player : Player, part : BasePart, tag : string) -- why would you need more then click detection on the server?

    if not self.Server.Handlers[tag] then
        warn("No handler for tag: " .. tag)
        return
    end

    local maxDistance = self.Server.Handlers[tag].MaxDistance or 100

    if (player.Character.PrimaryPart.Position - part.Position).Magnitude > maxDistance then
        return
    end

    self.Server.Handlers[tag]:Click(part, player) -- weird to have part as first argument

end


function SelectionService:RegisterSelection(selectionHandler, name)

    local SelectionModule = require(selectionHandler)
    SelectionModule:Init(self)

    self.Handlers[name] = SelectionModule

end

function SelectionService:KnitStart()

    for _, selectionHandler in ipairs(script.Parent.SelectionTypesServer:GetChildren()) do

        if selectionHandler.ClassName == "ModuleScript" then

            local name = string.gsub(selectionHandler.Name, ".lua", "")

            self:RegisterSelection(selectionHandler, name)



        end

    end

end

function SelectionService:KnitInit()

    self.Handlers = {}


    --[[for _,Selection in ipairs(CollectionService:GetTagged("Selection")) do
        self:SelectionAdded(Selection)
    end

    CollectionService:GetInstanceAddedSignal("Selection"):Connect(function(Selection : BasePart)

        self:SelectionAdded(Selection)

    end)]]

end









return SelectionService