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

function SpawnItems:SpawnIndividualItem(itemName, ancestor, customItemSpawns, amount)

    amount = amount or 1

    local newTable = {
        Battery = {
            SpawnsIn = {
                Drawer = 10,
                TVCabinets = 5,
            },
        },

        Soap = {
            SpawnsIn = {
                Drawer = 6,
            },
        },

        Lighter = {
            SpawnsIn = {
                Drawer = 5,
                TVCabinets = 3,
            },
        },

        Taser = {
            SpawnsIn = {
                Drawer = 1,
            },
        },

        Knife = {
            SpawnsIn = {
                KnifeHanger = 1,
            },
        },

        Fork = {
            SpawnsIn = {
                KitchenCabinet = 5,
            },
        },

        Medicine = {
            SpawnsIn = {
                KitchenCabinet = 2,
                TVCabinets = 1,
            },
        },

        Basement_Key = {
            SpawnsIn = {
                KitchenCabinet = 1,
            },
        },

    }

    local item = newTable[itemName]
    if not item then return end

    local allPossibleSpawns = {}
    local totalWeight = 0

    -- Gather all possible spawn locations with their weights
    for objectName, spawnWeight in pairs(item.SpawnsIn) do
        local tagged = CollectionService:GetTagged(objectName)
        for _, obj in ipairs(tagged) do
            if obj:IsDescendantOf(ancestor) then
                table.insert(allPossibleSpawns, {object = obj, weight = spawnWeight})
                totalWeight += spawnWeight
            end
        end
    end

    -- If we found possible spawn locations
    if #allPossibleSpawns > 0 then
        -- Pick one random location based on weights
        local randomValue = math.random() * totalWeight
        local currentWeight = 0

        for _, spawnInfo in ipairs(allPossibleSpawns) do
            currentWeight += spawnInfo.weight
            if randomValue <= currentWeight then
                -- Spawn the items at this location
                for _ = 1, amount do
                    _spawnItem(itemName, spawnInfo.object, ancestor)
                end
                break
            end
        end
    end



end

function SpawnItems:NewSpawn(ancestor, customItemSpawns)

    local newTable = {
        Battery = {
            SpawnsIn = {
                Drawer = 10,
                TVCabinets = 5,
            },
        },

        Soap = {
            SpawnsIn = {
                Drawer = 6,
            },
        },

        Lighter = {
            SpawnsIn = {
                Drawer = 5,
                TVCabinets = 3,
            },
        },

        Taser = {
            SpawnsIn = {
                Drawer = 1,
            },
        },

        Knife = {
            SpawnsIn = {
                KnifeHanger = 1,
            },
        },

        Fork = {
            SpawnsIn = {
                KitchenCabinet = 5,
            },
        },

        Medicine = {
            SpawnsIn = {
                KitchenCabinet = 2,
                TVCabinets = 1,
            },
        },

        Basement_Key = {
            SpawnsIn = {
                KitchenCabinet = 1,
            },
        },

    }

    for itemName, itemInfo in pairs(customItemSpawns or newTable) do
        for objectName, spawnAmount in pairs(itemInfo.SpawnsIn) do
            local spawnCount = 0
            local tagged = CollectionService:GetTagged(objectName)
            local taggedInsideAncestor = {}

            for _, obj in ipairs(tagged) do
                if obj:IsDescendantOf(ancestor) then
                    table.insert(taggedInsideAncestor, obj)
                end
            end

            if #taggedInsideAncestor > 0 then
                local totalObjects = #taggedInsideAncestor
                local itemsPerObject = math.ceil(spawnAmount / totalObjects)

                for _, obj in ipairs(taggedInsideAncestor) do
                    for _ = 1, itemsPerObject do
                        if spawnCount >= spawnAmount then
                            break
                        end
                        _spawnItem(itemName, obj, ancestor)
                        spawnCount += 1
                    end
                    if spawnCount >= spawnAmount then
                        break
                    end
                end
            else
                warn("No valid objects found for spawning item: " .. itemName .. " in " .. objectName)
            end
        end
    end

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