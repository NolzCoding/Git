local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ImageButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ImageButton)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local Knit = require(ReplicatedStorage.Packages.Knit)



local computed = Fusion.Computed
local forPairs = Fusion.ForPairs
local DefaultButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.DefaultButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local function QuestUI(scope, props)

    local QuestService = Knit.GetService("QuestService")
    local DataController = Knit.GetController("DataController")
    local DataService = Knit.GetService("DataService")

    local success, data = DataService.DataProperty:OnReady():await()

    local dailyQuests = scope:Value(data.Quests.DailyQuests)

    local lastDailyQuests = scope:Value(data.Quests.LastDailyQuest)

    local currentTime = scope:Value(DateTime.now().UnixTimestamp)

    task.spawn(function()
        while true do
            task.wait(1)
            currentTime:set(DateTime.now().UnixTimestamp)
        end
    end)

    DataController:OnDataChanged("Quests", function(quests)
        dailyQuests:set(quests.DailyQuests)
        lastDailyQuests:set(quests.LastDailyQuest)
    end)

    local Quests = {
        {
            Name = "Eat 5 batteries",
            Action = "Battery",
            Points = 20,
            Goal = 50,
        },
        {
            Name = "Eat 5 batteries",
            Action = "Battery",
            Points = 20,
            Goal = 50,
        },
        {
            Name = "Eat 5 batteries",
            Action = "Battery",
            Points = 50,
            Goal = 50,
        },
    }

    local dropDownRotation = scope:Value(180)
    local questScale = scope:Value(1)

	return scope:New("ScreenGui")({
		Name = "Quest",
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,

		[Children] = {
			scope:New("Frame")({
				Name = "Frame",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.987, 0.0545),
				Size = UDim2.fromScale(0.182, 0.448),

				[Children] = {
					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 0.86,
					}),

                    ImageButton(scope, {
                        Position = UDim2.fromScale(0.15, 0.05),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Size = UDim2.fromScale(0.2, 0.2),
                        AspectRatio = 1,
                        Rotation = scope:Tween(dropDownRotation, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
                        Image = Icons.DropDown,
                        ZIndex = 1,
                        ButtonUp = function()
                            dropDownRotation:set(Fusion.peek(dropDownRotation) == 180 and 0 or 180)
                            questScale:set(Fusion.peek(questScale) == 1 and 0 or 1)
                        end,
                    }),

					scope:New("Frame")({
						Name = "Frame",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,

						Position = UDim2.fromScale(0, 0.2),
						Size = UDim2.fromScale(1, 0.864),

						[Children] = {
							scope:New("UIListLayout")({
								Name = "UIListLayout",
								SortOrder = Enum.SortOrder.LayoutOrder,
                                HorizontalAlignment = Enum.HorizontalAlignment.Right,
							}),

                            scope:ForPairs(dailyQuests, function(use,scope,key,value)

                                local complete = scope:Computed(function(use)
                                    return value.Goal <= value.Points
                                end)


                                return key, scope:New("Frame")({
                                    Name = "Frame",
                                    AnchorPoint = Vector2.new(0.5, 0),
                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                    BackgroundTransparency = 1,
                                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                                    BorderSizePixel = 0,
                                    Size = UDim2.fromScale(1, 0.234),

                                    [Children] = {

                                        scope:New "UIScale" {
                                            Scale = scope:Tween(questScale, scope:Computed(function(use)

                                                if use(questScale) == 0 then
                                                    return TweenInfo.new(key/10, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                                                end

                                                return TweenInfo.new(key/10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                                            end)),
                                        },

                                        scope:New("TextLabel")({
                                            Name = "Quest",
                                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                            BackgroundTransparency = 1,
                                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                                            BorderSizePixel = 0,
                                            FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                            Size = UDim2.fromScale(1, 0.443),
                                            Text = value.Name,
                                            TextColor3 = Color3.fromRGB(255, 255, 255),
                                            TextScaled = true,
                                            TextSize = 14,
                                            TextWrapped = true,
                                            TextXAlignment = Enum.TextXAlignment.Right,

                                            [Children] = {
                                                scope:New("UIStroke")({
                                                    Name = "UIStroke",
                                                    Color = Color3.fromRGB(4, 27, 18),
                                                    Thickness = 2,
                                                }),
                                            },
                                        }),

                                        scope:New("UICorner")({
                                            Name = "UICorner",
                                            CornerRadius = UDim.new(0.3, 0),
                                        }),

                                        scope:New("ImageLabel")({
                                            Name = "ImageLabel",
                                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                            BackgroundTransparency = 1,
                                            BorderColor3 = Color3.fromRGB(27, 42, 53),
                                            Image = "rbxassetid://11953711609",
                                            ImageColor3 = Color3.fromRGB(0, 0, 0),
                                            ImageTransparency = 0.56,
                                            Position = UDim2.fromScale(-0.0751, -0.589),
                                            Size = UDim2.fromScale(1.881, 2.59),
                                            SliceCenter = Rect.new(20, 20, 108, 108),
                                            ZIndex = -1,
                                        }),

                                        DefaultButton(scope, {

                                            Size = UDim2.fromScale(1, 0.443),
                                            Visible = complete,
                                            Position = UDim2.fromScale(0.8, 0.75),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            Text = "Claim",
                                            ButtonUp = function()
                                                QuestService:Claim(key) -- key is the index of the quest
                                            end,

                                            ButtonDown = function()
                                            end,

                                        }),

                                        scope:New("TextLabel")({
                                            Name = "Quest",
                                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                            BackgroundTransparency = 1,
                                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                                            BorderSizePixel = 0,
                                            FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                            Position = UDim2.fromScale(0, 0.441),
                                            Size = UDim2.fromScale(1, 0.443),
                                            Visible = scope:Computed(function(use)
                                                return not use(complete)
                                            end),
                                            Text = value.Points .. " / " .. value.Goal,
                                            TextColor3 = Color3.fromRGB(255, 255, 255),
                                            TextScaled = true,
                                            TextSize = 14,
                                            TextWrapped = true,
                                            TextXAlignment = Enum.TextXAlignment.Right,

                                            [Children] = {
                                                scope:New("UIStroke")({
                                                    Name = "UIStroke",
                                                    Color = Color3.fromRGB(4, 27, 18),
                                                    LineJoinMode = Enum.LineJoinMode.Bevel,
                                                    Thickness = 2,
                                                    Transparency = 0.83,
                                                }),
                                            },
                                        }),
                                    },
                                })

                            end)

						},
					}),

					scope:New("TextLabel")({
						Name = "Quest",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
						Position = UDim2.fromScale(0.0781, -0.0249),
						Size = UDim2.fromScale(0.921, 0.128),
						Text = "Daily Quest",
						TextColor3 = Color3.fromRGB(161, 255, 102),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Right,

						[Children] = {
							scope:New("UIStroke")({
								Name = "UIStroke",
								Color = Color3.fromRGB(6, 44, 29),
								LineJoinMode = Enum.LineJoinMode.Bevel,
								Thickness = 3,
							}),
						},
					}),

                    scope:New("TextLabel")({
                        Name = "Resets",
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        AnchorPoint = Vector2.new(1, 0),
                        FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                        Size = UDim2.fromScale(1, 0.08),
                        Position = UDim2.fromScale(1, 0.1),
                        Text = scope:Computed(function(use)

                            local timee = use(currentTime)
                            local lastQuest = use(lastDailyQuests)

                            local timeLeft = 86400 - (timee - lastQuest)

                            local hours = math.floor(timeLeft / 3600)
                            local minutes = math.floor((timeLeft % 3600) / 60)
                            local seconds = math.floor(timeLeft % 60)

                            return string.format("Resets in %02d:%02d:%02d", hours, minutes, seconds)

                        end),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextScaled = true,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Right,

                        [Children] = {
                            scope:New("UIStroke")({
                                Name = "UIStroke",
                                Color = Color3.fromRGB(4, 27, 18),
                                Thickness = 2,
                            }),
                        },
                    }),

				},
			}),
		},
	})
end


return QuestUI