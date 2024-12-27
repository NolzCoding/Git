local SpawnItems = {}

local CollectionService = game:GetService("CollectionService")

local currnetItemsInWorld = {}

local itemSpawns = {

    Drawer = {
        Battery = {
            Max = 1,
            Min = 1,
            Chance = 0.1,
        },

        Fork = {
            Max = 1,
            Min = 1,
            Chance = 0.2,
        },

        Soap = {
            Max = 1,
            Min = 1,
            Chance = 0.2,
        },

        Lighter = {
            Max = 1,
            Min = 1,
            Chance = 0.5,
        },

        Taser = {
            Max = 1,
            Min = 1,
            Chance = 0.05,
        },

    },

    Locker = {
        Battery = {
            Max = 1,
            Min = 1,
            Chance = 0.5,
        },

        Lighter = {
            Max = 1,
            Min = 1,
            Chance = 0.2,
        },


    },


}

local function _retriveVisual(name) : Model?

    local visual = script.Parent.Items:FindFirstChild(name):FindFirstChild("Visual")
    if not visual then
        warn("Visual not found for item: " .. name)
        return
    end

    return visual

end

function SpawnItems:HandleObject(object, type)

    local chances = itemSpawns[type]

    if not chances then return end

    for name, info in pairs(chances) do
        if math.random() < info.Chance then
            local visual = _retriveVisual(name)
            if not visual then continue end

            local clone = visual:Clone()
            local pivot = object:GetPivot()
            local size = object.Size

            local insides = object:FindFirstChild("Insides")

            if insides then
                pivot = insides:GetPivot()
                size = insides.Size
            end
            math.randomseed(tick())
            clone:PivotTo(pivot + Vector3.new(math.random(-size.X/2, size.X/2), 0, math.random(-size.Z/2, size.Z/2))) -- Randomize the position
            clone.Parent = workspace
            local newWeldConstraint = Instance.new("WeldConstraint")
            newWeldConstraint.Parent = clone
            newWeldConstraint.Part0 = insides or object
            newWeldConstraint.Part1 = clone.PrimaryPart

            local proximityPrompt = clone.PrimaryPart:WaitForChild("ProximityPrompt") :: ProximityPrompt
            local OpenAttribute = object:GetAttribute("Open")
            proximityPrompt.Enabled = OpenAttribute

            object:GetAttributeChangedSignal("Open"):Connect(function(...: any)
                proximityPrompt.Enabled = object:GetAttribute("Open")
            end)

            table.insert(currnetItemsInWorld, clone)
            print("Spawned item: " .. name)
        end
    end

end

function SpawnItems:Spawn()

    for name, items in pairs(itemSpawns) do
        local tagged = CollectionService:GetTagged(name)
        for _, object in ipairs(tagged) do
            self:HandleObject(object, name)
        end
    end

end

function SpawnItems:DestroyAllItems()

    for _, item in ipairs(currnetItemsInWorld) do
        item:Destroy()
    end

end

return SpawnItems