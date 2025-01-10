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


        Soap = {
            Max = 1,
            Min = 1,
            Chance = 0.2,
        },

        Lighter = {
            Max = 1,
            Min = 1,
            Chance = 0.1,
        },

        Taser = {
            Max = 1,
            Min = 1,
            Chance = 0.01,
        },

    },

    TVCabinets = {
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

    KnifeHanger = {

        Knife = {
            Max = 1,
            Min = 1,
            Chance = 1,
        },

    },

    KitchenCabinet = {

        Fork = {
            Max = 1,
            Min = 1,
            Chance = 0.5,
        },

        Medicine = {
            Max = 1,
            Min = 1,
            Chance = 0.3,
        },

        Basement_Key = {
            Max = 1,
            Min = 1,
            Chance = 0.05,
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


local function _spawnItem(name, object, ancestor)
    local visual = _retriveVisual(name)
    if not visual then return end

    local clone = visual:Clone()
    local pivot = object:GetPivot()
    local size = object.Size

    local insides = object:FindFirstChild("Insides")

    if insides then
        pivot = insides:GetPivot()
        size = insides.Size
    end
    clone:PivotTo(pivot + Vector3.new(math.random(-size.X/2, size.X/2), 0, math.random(-size.Z/2, size.Z/2))) -- Randomize the position
    clone.Parent = ancestor
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

    return clone
end

function SpawnItems:HandleObject(object, type, ancestor, customItemSpawns)

    local chances = (customItemSpawns or itemSpawns)[type]

    if not chances then return end

    local rng = Random.new()

    for name, info in pairs(chances) do
        if rng:NextNumber() < info.Chance then
            _spawnItem(name, object, ancestor)
        end
    end

end

function SpawnItems:SpawnIndividualItem(itemName, ancestor, customItemSpawns)

    local possibleObjects = {}

    for name, items in pairs(customItemSpawns or itemSpawns) do
        for nameOfItem, _ in pairs(items) do
            if nameOfItem == itemName then
                table.insert(possibleObjects, name)
            end
        end
    end
    -- random object

    local object = possibleObjects[math.random(1, #possibleObjects)]
    local tagged = CollectionService:GetTagged(object)
    local taggedInsideAncestor = {}

    for _, obj in ipairs(tagged) do
        if not obj:IsDescendantOf(ancestor) then
            continue
        end
        table.insert(taggedInsideAncestor, obj)
    end
    local randomObject = taggedInsideAncestor[math.random(1, #taggedInsideAncestor)]

    _spawnItem(itemName, randomObject, ancestor)

    print("Spawned item: ", itemName, " in ", randomObject)

    return itemName

end

function SpawnItems:Spawn(ancestor, customItemSpawns)

    for name, items in pairs(customItemSpawns or itemSpawns) do
        local tagged = CollectionService:GetTagged(name)

        for _, object in ipairs(tagged) do

            if not object:IsDescendantOf(ancestor) then
                continue
            end

            self:HandleObject(object, name, ancestor, customItemSpawns)
        end
    end

end

function SpawnItems:DestroyAllItems()

    for _, item in ipairs(currnetItemsInWorld) do
        item:Destroy()
    end

end

return SpawnItems