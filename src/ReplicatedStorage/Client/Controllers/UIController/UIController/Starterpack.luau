local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local children = Fusion.Children
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
local MarketplaceService = game:GetService("MarketplaceService")
local ImageButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ImageButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
type scope = typeof(Fusion.scoped(Fusion))
local function Starterpack(scope : scope, props : {

})

    local visible = scope:Value(true)

    local maxtime = 180

    local currentTime = scope:Value(maxtime)

    task.spawn(function()
        while peek(currentTime) ~= 0 do
            task.wait(1)
            currentTime:set(peek(currentTime) - 1)
        end
    end)


    local ID = 2695770303
    local info = MarketplaceService:GetProductInfo(ID, Enum.InfoType.Product)

    local price = info.PriceInRobux
    local image = "rbxassetid://" .. info.IconImageAssetId

    return ImageButton(scope, {
        Image = image,
        Position = UDim2.fromScale(0.75, 0.1),
        Size = UDim2.fromScale(0.15, 0.15),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ButtonUp = function()
            MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, ID)
        end,
        Visible = visible,
        Build = function(scope)

            return {ImageButton(scope ,{
				Name = "Close",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
                ZIndex = 2,
				Image = "rbxassetid://4963445748",
				Position = UDim2.fromScale(1,0),
                AnchorPoint = Vector2.new(0.5, 0.5),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.2, 0.2),
				ZIndex = 2,
                ButtonUp = function()
                    visible:set(false)
                    MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, ID)
                end,
			}),

            scope: New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },

            scope: New "TextLabel" {
                Size = UDim2.new(1, 0, 0.3, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.8, 0),
                BackgroundTransparency = 1,
                Text = scope:Computed(function(use, scope)

                    local time = use(currentTime)
                    local minutes = math.floor(time / 60)
                    local seconds = time % 60

                    return string.format("%02d:%02d", minutes, seconds)

                end),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                Font = Enum.Font.FredokaOne,
                [Children] = {
                    scope:New "UIStroke" {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 2,
                    },
                },
            }

        }

        end

    })

end

return Starterpack