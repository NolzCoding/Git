local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ObjectService = Knit.CreateService{Name = "ObjectService", Client = {}}

function ObjectService:KnitInit()
    self.ObjectModules = {}

    for _, moduleScript in ipairs(script.Objects:GetChildren()) do
        self:RequireModule(moduleScript.Name)
    end

end

function ObjectService:KnitStart()
    for _,v in pairs(self.ObjectModules) do
        if v.Init then
            v:Init()
        end
    end
    -- init
    for _, object in ipairs(CollectionService:GetTagged("ObjectService")) do
        local tags = object:GetTags()

        for _, tag in ipairs(tags) do
            if self.ObjectModules[tag] then
                self:ObjectAdded(object, tag)
                break
            end
        end
    end

    CollectionService:GetInstanceAddedSignal("ObjectService"):Connect(function(object)
        -- find tag

        local tags = object:GetTags()

        for _, tag in ipairs(tags) do
            print(tag)
            if self.ObjectModules[tag] then
                self:ObjectAdded(object, tag)
                return
            end
        end

    end)

end

function ObjectService:ObjectAdded(object : PVInstance, ModuleName : string)
    -- must be inside workspace because you might want to store objects in replicatedstorage/serverstorage

    if not object:IsDescendantOf(game.Workspace) then return end

    local potentialProps = object:GetAttributes()

    local parent = object.Parent
    local cframe = object:GetPivot()

    object:Destroy()

    local object = self:InstanceObject(ModuleName, cframe, parent, potentialProps)

end

function ObjectService:RequireModule(ModuleName : string)

    local moduleScript = script.Objects:FindFirstChild(ModuleName)

    if not moduleScript then
        warn("Module" .. ModuleName .. "not found")
        return
    end

    moduleScript = moduleScript:FindFirstChild(ModuleName)

    local module = require(moduleScript)
    self.ObjectModules[ModuleName] = module

    return module

end

function ObjectService:AddPropertiesAsAttributes(Object : Instance, Properties : table?)

    if not Properties then
        return
    end

    for key, value in pairs(Properties) do
        Object:SetAttribute(key, value)
    end

end

function ObjectService:InstanceObject(ObjetName : string, CFrame : CFrame, Parent : Instance, Properties : table?)

    local module = self.ObjectModules[ObjetName]

    if not module then
        warn("Module not found")
        return
    end

    local object = module:Instance(CFrame, Parent, function(object : Instance)
        self:AddPropertiesAsAttributes(object,Properties)
    end)

    return object

end

function ObjectService:CallMethod(objectName, methodName, ...)

    local module = self.ObjectModules[objectName]

    if not module then
        warn("Module not found")
        return
    end

    local method = module[methodName]

    if method then
        return method(module, ...)
    else
        warn("Method not found")
    end

end


return ObjectService