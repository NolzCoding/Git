local SkinBuy = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local computed = Fusion.Computed
local forValues = Fusion.ForValues
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Section = require(script.Parent.Parent.Parent.Components.UI.Section)
local Sticker = require(script.Parent.Parent.Parent.Components.UI.Sticker)
local AbsoluteScaleComputed = require(ReplicatedStorage.Source.Shared.Uitility.AbsoluteScaleComputed)
local ImageButton = require(script.Parent.Parent.Parent.Components.Buttons.ImageButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local TweenService = game:GetService("TweenService")
function SkinBuy:Start() -- knit start
end

local AchivementInfo = require(ReplicatedStorage.Source.Shared.Achievements)


function SkinBuy:newProduct(id)

    local productInfo = MarketplaceService:GetProductInfo(id, Enum.InfoType.Product)

    self.ProductImage:set(productInfo.IconImageAssetId)
    self.ProductName:set(productInfo.Name)
    self.ProductPrice:set(productInfo.PriceInRobux)
    self.ProductId:set(id)

end

function SkinBuy:OnOpen(...)

    local productID = ...

    self:newProduct(productID)

end

function SkinBuy:Build(scope: typeof(Fusion.scoped(Fusion)), open)

    self.ProductImage = scope:Value("")
    self.ProductName = scope:Value("")
    self.ProductPrice = scope:Value(0)
    self.ProductId = scope:Value(0)



	return Window(scope, {
		HeaderText = self.ProductName,
		Size = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Open = open,
		Build = function(scope)
			return scope:New("Frame")({
				Name = "Frame",
                ZIndex = 5,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.534),
				Size = UDim2.fromScale(0.8, 0.8),

				[Children] = {
					scope:New("UICorner")({
						Name = "UICorner",
					}),

					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 1.33,
					}),

					Sticker(scope,{
						Name = "TextLabel",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Position = UDim2.fromScale(0.22, 0.0731),
						Size = UDim2.fromScale(0.44, 0.146),
						Text = "LIMITED",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,
					}),

					DefaultButton(scope,{
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(123, 255, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Position = UDim2.fromScale(0.499, 0.909),
						Size = UDim2.fromScale(0.44, 0.3),
						Text = scope:Computed(function(use)
                            return use(self.ProductPrice) .. " R$"
                        end),
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,

                        ButtonUp = function()
                            MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, Fusion.peek(self.ProductId))
                        end,

                        ButtonDown = function()
                        end,

                        Build = function(scope)
                            return Sticker(scope,{
								Name = "TextLabel",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
								Position = UDim2.fromScale(0.925, -0.0912),
								Size = UDim2.fromScale(0.52, 0.52),
								Text = "50% OFF",
								TextColor3 = Color3.fromRGB(0, 0, 0),
								TextSize = 14,})

                        end

					}),

					scope:New("ImageLabel")({
						Name = "ImageButton",
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = scope:Computed(function(use)
                            return "rbxassetid://" .. use(self.ProductImage)
                        end),
						Position = UDim2.fromScale(0.499, 0.436),
						Selectable = true,
						Size = UDim2.fromScale(0.8, 0.8),
						ZIndex = 0,

						[Children] = {

                            scope:New("UIAspectRatioConstraint")({
                                Name = "UIAspectRatioConstraint",
                                AspectRatio = 1,
                            }),


							scope:New("UIGradient")({
								Name = "UIGradient",
								Rotation = 57,
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 0),
									NumberSequenceKeypoint.new(0.392, 0),
									NumberSequenceKeypoint.new(0.498, 0.431),
									NumberSequenceKeypoint.new(0.607, 0),
									NumberSequenceKeypoint.new(1, 0),
								}),
							}),
						},
					}),
				},
			})
		end,
	})
end

return SkinBuy
