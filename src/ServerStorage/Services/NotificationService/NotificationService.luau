local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local NotificationService = Knit.CreateService {
    Name = "NotificationService";
    Client = {

        NotifySignal = Knit.CreateSignal()

    }

}

function NotificationService:KnitStart()


    task.delay(10, function()

        self:NotifyPlayer("TextNImage", {
            Text = "Sent from server",
            Image = Icons.Rocket,
            Color = Color3.fromRGB(115, 255, 0),
            Time = 5,
        }, true)

    end)

end


function NotificationService:NotifyPlayer(notificationName, props : {
    Text : string,
    Image : string,
    Color : Color3,
    Time : number,
}, playerOrBool : Player | boolean)

    if typeof(playerOrBool) == "boolean" or playerOrBool == nil then
        self.Client.NotifySignal:FireAll(notificationName, props)
        return
    end

    self.Client.NotifySignal:Fire(playerOrBool, notificationName, props)

end

return NotificationService