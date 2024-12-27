local Shop = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local forValues = Fusion.ForValues
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Section = require(script.Parent.Parent.Parent.Components.UI.Section)
local AbsoluteScaleComputed = require(ReplicatedStorage.Source.Shared.Uitility.AbsoluteScaleComputed)
local ImageButton = require(script.Parent.Parent.Parent.Components.Buttons.ImageButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Item = require(script.Item)
local TweenService = game:GetService("TweenService")
function Shop:Start() -- knit start
end

function Shop:Build(scope : typeof(Fusion.scoped(Fusion)), open)

    self.UIController = Knit.GetController("UIController")
    self.DataService = Knit.GetService("DataService")
    self.DataController = Knit.GetController("DataController")

    ready, data = self.DataService.DataProperty:OnReady():await()

    local crates = scope:Value(data.Inventory.Crates)
    print(Fusion.peek(crates))
    self.DataController:OnDataChanged("Inventory", function(inventory)
        crates:set(inventory.Crates)
    end)

	return Window(scope, {
        Size = UDim2.fromScale(0.5, 0.5),
		HeaderText = "Shop",
		Open = open,
		Build = function(scope)

            local absoluteCanvasSize = scope:Value(Vector2.new(500,500))



            local scrollingFrame : ScrollingFrame = scope:New "ScrollingFrame" {
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
                        Size = AbsoluteScaleComputed(scope, absoluteCanvasSize, UDim2.fromScale(1, 1)),
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

                            end),



                        }
                    },

                    scope:Computed(function(use, scope)

                        return Section(scope, {
                            Name = "Your Crates",
                            Size = AbsoluteScaleComputed(scope, absoluteCanvasSize, UDim2.fromScale(1, 1)),
                            AutomaticSize = Enum.AutomaticSize.None,
                            Padding = 75,
                            Build = function(scope)

                                return {
                                    scope : New "UIGridLayout" {
                                        CellSize = AbsoluteScaleComputed(scope, absoluteCanvasSize, UDim2.fromScale(0.25, 0.5)),
                                       -- CellPadding = UDim2.fromOffset(0.03, 0),

                                        FillDirection = Enum.FillDirection.Horizontal,
                                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                        VerticalAlignment = Enum.VerticalAlignment.Top,
                                    },

                                    Item(scope, {
                                        Equipped = false,
                                        Amount = scope:Computed(function(use)
                                            print(use(crates)["Skin Crate"])
                                            return use(crates)["Skin Crate"] or 0
                                        end),
                                        ImageSize = UDim2.fromScale(0.8, 0.8),
                                        Name = "Item 1",
                                        RarityColor = Color3.fromRGB(255, 103, 103),
                                        Image = Icons.GiftBoxes.Purple.Large,
                                        Clicked = function()
                                            self.UIController:CloseWindow("Shop")
                                            self.UIController:OpenWindow("RollItem", "Skin Crate")
                                        end,

                                    }),

                                    Item(scope, {
                                        Equipped = false,
                                        Amount = scope:Computed(function(use)
                                            return use(crates)["Epic Skin Crate"] or 0
                                        end),
                                        Name = "Item 1",
                                        ImageSize = UDim2.fromScale(0.8, 0.8),

                                        RarityColor = Color3.fromRGB(8, 255, 152),
                                        Image = Icons.GiftBoxes.Green.Large,
                                        Clicked = function()
                                            self.UIController:CloseWindow("Shop")
                                            self.UIController:OpenWindow("RollItem", "Starter Crate")
                                        end,

                                    }),

                                    Item(scope, {
                                        Equipped = false,
                                        Amount = scope:Computed(function(use)
                                            return use(crates)["Ability Crate"] or 0
                                        end),
                                        ImageSize = UDim2.fromScale(0.8, 0.8),

                                        Name = "Item 1",
                                        RarityColor = Color3.fromRGB(207, 87, 255),
                                        Image = Icons.GiftBoxes.Purple.Large,
                                        Clicked = function()
                                            self.UIController:CloseWindow("Shop")
                                            self.UIController:OpenWindow("RollItem", "Ability Crate")
                                        end,

                                    }),

                                }
                            end
                        })

                    end)

                }

            }

            absoluteCanvasSize:set(scrollingFrame.AbsoluteWindowSize)

            scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
                absoluteCanvasSize:set(scrollingFrame.AbsoluteWindowSize)
            end)



            local listSections = {
                {
                    Name = "Gems",
                    Image = Icons.Rocket,
                    CanvasPositon = Vector2.new(0, 0),
                },
                {
                    Name = "Crates",
                    Image = Icons.GiftBoxes.Purple.Large,
                    CanvasPositon = scope:Computed(function(use, scope)
                        local udim2 = use(AbsoluteScaleComputed(scope, absoluteCanvasSize, UDim2.fromScale(0, 1)))
                        return Vector2.new(udim2.X.Offset, udim2.Y.Offset)
                    end),

                },

            }

            local ListFrame = scope:New "Frame" {
                Size = UDim2.new(0.1, 0, 1, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundTransparency = 1,
                [Children] = {
                    scope : New "UIListLayout" {
                        Padding = UDim.new(0.05, 0),
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                    },

                    scope:ForValues(listSections, function(use, scope, value)


                        return ImageButton(scope, {
                            Size = UDim2.fromScale(1, 0.2),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = value.Image,
                            ButtonUp = function()

                                TweenService:Create(scrollingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                                    CanvasPosition = Fusion.peek(value.CanvasPositon),
                                }):Play()

                            end,

                        })

                    end),

                },
            }

			return {
                scrollingFrame,
                ListFrame,
			}
		end,
	})
end

return Shop
