local module = {}

-- calculate the level of a player based on their experience


module.Labels = {
    Novice = 1,
    Beginner = 5,
    Intermediate = 10,
    Advanced = 15,
}

function module:GetLevelLabel(level : number) : string
    for label, levelValue in pairs(module.Labels) do
        if level < levelValue then
            return label
        end
    end
    return "Expert"
end

function module:GetNextLevelExperience(level : number) : number
    return 100 + (level * 50)
end

return module