local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
type scope = typeof(Fusion.scoped(Fusion))
local function Component(scope : scope, props : {
    Expires : number,
})

    local currentTime = scope:Value(DateTime.now().UnixTimestamp)

    local coru = coroutine.create(function()
        while true do
            currentTime:set(DateTime.now().UnixTimestamp)
            wait(1)
        end
    end)

    coroutine.resume(coru)

    table.insert(scope, coru)

    return scope:Computed(function(use)
        local currentTime = use(currentTime)

        local timeToEnd = props.Expires - currentTime

        -- days hour minutes seconds
        -- or hours minutes seconds if less than a day

        local days = math.floor(timeToEnd / 86400)
        local hours = math.floor((timeToEnd % 86400) / 3600)
        local minutes = math.floor((timeToEnd % 3600) / 60)
        local seconds = math.floor(timeToEnd % 60)

        if days > 0 then
            return string.format("Ends in: %d days %d h %d mins %d sec", days, hours, minutes, seconds)
        else
            return string.format("Ends in: %d h %d mins %d sec", hours, minutes, seconds)
        end

    end)
end

return Component