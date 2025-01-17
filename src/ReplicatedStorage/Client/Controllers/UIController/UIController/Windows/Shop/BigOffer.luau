local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local computed = Fusion.Computed
local Endsin = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Util.Endsin)
local DefaultButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.DefaultButton)
local Sticker = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.UI.Sticker)
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
local MarketplaceService = game:GetService("MarketplaceService")

type scope = typeof(Fusion.scoped(Fusion))



local function BigOffer(scope: scope, props: {

    Name : string,
    Price1 : number,
    Price3 : number,
    Product1 : number,
    Product3 : number,
    Expires : number,
    Size : UDim2?,
    Position : UDim2?,
    Content : (scope : scope) -> {},

})

    -- fetch prize
    local info1 = MarketplaceService:GetProductInfo(props.Product1, Enum.InfoType.Product)
    local info3 = MarketplaceService:GetProductInfo(props.Product3, Enum.InfoType.Product)

    local prize1 = info1.PriceInRobux
    local prize3 = info3.PriceInRobux

	return scope:New("Frame")({
		Name = "BigCard",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = props.Position or UDim2.fromScale(0.0281, 0.0697),
		Size = props.Size or UDim2.fromScale(0.936, 0.561),

		[Children] = {
			scope:New("UICorner")({
				Name = "UICorner",
				CornerRadius = UDim.new(0.15, 0),
			}),

			scope:New("UIGradient")({
				Name = "UIGradient",
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 51)),
				}),
				Rotation = 82,
			}),

			scope:New("UIStroke")({
				Name = "UIStroke",
				Color = Color3.fromRGB(130, 73, 26),
				Thickness = 2,
			}),

			scope:New("ImageLabel")({
				Name = "Pattern",
				BackgroundTransparency = 1,
				Image = "rbxassetid://2151781758",
				ImageTransparency = 0.6,
				Position = UDim2.fromScale(0.0171, 0),
				ScaleType = Enum.ScaleType.Tile,
				Size = UDim2.fromOffset(458, 137),
				TileSize = UDim2.fromOffset(30, 60),
				ZIndex = 0,

				[Children] = {
					scope:New("UIGradient")({
						Name = "UIGradient",
						Rotation = 55,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(0.591, 1),
							NumberSequenceKeypoint.new(1, 1),
						}),
					}),
				},
			}),

			scope:New("Frame")({
				Name = "Contents",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.277, 0.508),
				Size = UDim2.fromScale(0.48, 0.754),
                [Children] = {
                    props.Content and props.Content(scope),
                },
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.126, 0),
				Rotation = -6,
				Size = UDim2.fromScale(0.431, 0.365),
				Text = props.Name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Thickness = 2,
					}),
				},
			}),

			scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 3.39,
			}),

			DefaultButton(scope, {
				Name = "TextButton",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(157, 255, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.64, 0.761),
				Size = UDim2.fromScale(0.3, 0.3),
				Text = "BUY 3",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
                ButtonDown = function()

                    MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, peek(props.Product3))

                end,

                ButtonUp = function() end,

                Build = function(scope)

                    return Sticker(scope, {
                        Text = scope:Computed(function()
                            -- calculate difference between price1 and price3 to insentivize buying 3
                            local diff = prize1*3 - prize3
                            return string.format("Save %d R$", diff)

                        end),
                        Position = UDim2.fromScale(1, 1.2),
                        Size = UDim2.fromScale(1, 1),
                    })

                end

			}),

            DefaultButton(scope, {
				Name = "TextButton",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(157, 255, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.87, 0.761),
				Size = UDim2.fromScale(0.3, 0.3),
				Text = "BUY 1",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
                ButtonDown = function()

                    MarketplaceService:PromptProductPurchase( game.Players.LocalPlayer,peek(props.Product1))
                end,

                ButtonUp = function() end,
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/FredokaOne.json",
					Enum.FontWeight.Regular,
					Enum.FontStyle.Italic
				),
				Position = UDim2.fromScale(0.553, 0.496),
				Size = UDim2.fromScale(0.186, 0.19),
				Text = prize3,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Right,
			}),

			scope:New("ImageLabel")({
				Name = "ImageLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://124710613875677",
				Position = UDim2.fromScale(0.687, 0.496),
				Size = UDim2.fromScale(0.056, 0.19),
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/FredokaOne.json",
					Enum.FontWeight.Regular,
					Enum.FontStyle.Italic
				),
				Position = UDim2.fromScale(0.787, 0.496),
				Size = UDim2.fromScale(0.186, 0.19),
				Text = prize1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Right,
			}),

			scope:New("ImageLabel")({
				Name = "ImageLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://124710613875677",
				Position = UDim2.fromScale(0.922, 0.496),
				Size = UDim2.fromScale(0.056, 0.19),
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.72, -0.0372),
				Size = UDim2.fromScale(0.515, 0.174),
				Text = Endsin(scope, {
                    Expires = props.Expires,
                }),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Thickness = 2,
					}),
				},
			}),
		},
	})
end

return BigOffer
