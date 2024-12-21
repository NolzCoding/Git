local Shop = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
function Shop:Start() -- knit start
end

function Shop:Build(scope : typeof(Fusion.scoped(Fusion)), open)
	return Window(scope, {
		HeaderText = "Shop",
		Open = open,
		Build = function(scope)
			return {


				scope:New "ScrollingFrame" {
                    ZIndex = 3,
					Size = UDim2.new(0.95, 0, 0.8, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 4, 0),
                    [Children] = {
                        scope : New "UIListLayout" {
                            FillDirection = Enum.FillDirection.Vertical,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                        },

                        scope:New "Frame" {
                            Size = UDim2.new(1, 0, 1/4, 0),
                            BackgroundTransparency = 1,
                            [Children] = {

                                scope : New "UIGridLayout" {
                                    CellSize = UDim2.fromScale(0.49, 0.5),
                                   -- CellPadding = UDim2.fromOffset(0.03, 0),

                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,
                                },

                                scope:Computed(function(use)
                                    local cards = {

                                        {
                                            Title = "Card 1",
                                            Description = "This is a description of card 1",
                                            Price = 100,
                                            Image = "rbxassetid://70566867826486",
                                        },
                                        {
                                            Title = "Card 2",
                                            Description = "This is a description of card 2",
                                            Price = 200,
                                            Image = "rbxassetid://70566867826486",
                                        },
                                        {
                                            Title = "Card 3",
                                            Description = "This is a description of card 3",
                                            Price = 300,
                                            Image = "rbxassetid://70566867826486",
                                        },
                                        {
                                            Title = "Card 4",
                                            Description = "This is a description of card 4",
                                            Price = 400,
                                            Image = "rbxassetid://70566867826486",
                                        },

                                    }

                                    local children = {}

                                    for _,v in ipairs(cards) do

                                        local Id = 2666292727

                                        local info =  MarketplaceService:GetProductInfo(Id, Enum.InfoType.Product)
                                        local image = "rbxassetid://" ..  info.IconImageAssetId


                                        children[#children + 1] = Card(scope, {

                                            Build = function(scope)
                                                return {DefaultButton(scope, {
                                                    Size = UDim2.fromScale(0.4, 0.4),
                                                    Position = UDim2.fromScale(0.7, 0.7),
                                                    Text = info.PriceInRobux .. " R$",
                                                    ZIndex = 1,
                                                    ButtonUp = function()
                                                        print("Button Up")
                                                    end,
                                                    ButtonDown = function()
                                                        print("Button Down")
                                                    end,
                                                }),

                                                TextLabelWithStroke(scope, {
                                                    Text = v.Title,
                                                    Size = UDim2.fromScale(0.5, 0.2),
                                                    Position = UDim2.fromScale(0, 0.65),
                                                    ZIndex = 2,
                                                    Thickness = 1,
                                                    StrokeColor = Color3.fromRGB(20, 18, 8),
                                                    TextColor = Color3.fromRGB(231, 216, 148),
                                                }),

                                                scope:New "ImageLabel" {
                                                    Size = UDim2.fromScale(0.5, 0.8),
                                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                                    Position = UDim2.fromScale(0.25, 0.4),
                                                    ZIndex = 2,
                                                    Image = image,
                                                    BackgroundTransparency = 1,
                                                    [Children] = {
                                                        scope:New "UIAspectRatioConstraint" {
                                                            AspectRatio = 1,
                                                        },
                                                    },
                                                }}

                                            end
                                        })
                                    end

                                    return children

                                end)
                            }
                        }

                    }

                },
			}
		end,
	})
end

return Shop
