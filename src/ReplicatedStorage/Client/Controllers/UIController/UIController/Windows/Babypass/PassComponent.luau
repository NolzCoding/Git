local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
local children = Fusion.Children
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local event = Fusion.OnEvent
local tween = Fusion.Tween
type scope = typeof(Fusion.scoped(Fusion))
local BattlePass = require(ReplicatedStorage.Source.Shared.Battlepass)
local function PassComponent(
	scope: scope,
	props: {
		Size: UDim2?,
		Position: UDim2?,
		Pass: { BattlePass.PassLevel },
		Locked: boolean,
        Claimed : {boolean},
        PassEXP : number,
        OnClaim : (number) -> (),
		AvailableToClaim : boolean,
	}
)
	return scope:New("CanvasGroup")({
		Name = "CanvasGroup",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = props.Position or UDim2.fromScale(0, 0.13),
		Size = props.Size or UDim2.fromScale(0.998, 0.391),
		[Children] = {
			scope:New("ScrollingFrame")({
				Name = "ScrollingFrame",
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = UDim2.fromScale(6, 0),
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				Position = UDim2.fromScale(0.5, 0.5),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					scope:New("Frame")({
						Name = "Frame",
						BackgroundColor3 = Color3.fromRGB(49, 49, 49),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.fromScale(0.107, 0.591),

						[Children] = {
							scope:New("UIAspectRatioConstraint")({
								Name = "UIAspectRatioConstraint",
								AspectRatio = 0.78,
							}),

							scope:New("UICorner")({
								Name = "UICorner",
							}),

							scope:New("ImageButton")({
								Name = "ImageButton",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Image = "rbxassetid://74641606755800",
								ImageColor3 = Color3.fromRGB(255, 49, 49),
								ImageTransparency = 1,
								Size = UDim2.fromScale(1, 1),
								[Children] = {
									scope:New("UIScale")({}),
								},
							}),
						},
					}),

					scope:New("UIListLayout")({
						Name = "UIListLayout",
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 10),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					scope:ForPairs(props.Pass, function(use, scope, key, value : BattlePass.PassLevel)
						local scale = scope:Value(1)
						local position = scope:Value(UDim2.new(0.5, 0, 0.5, 0))

						return key, scope:New("Frame")({
							Name = "Frame",
							BackgroundColor3 = Color3.fromRGB(49, 49, 49),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(-0.00404, 0),
							Size = UDim2.fromScale(0.196, 0.971),
							[Children] = {
								scope:New("UIAspectRatioConstraint")({
									Name = "UIAspectRatioConstraint",
									AspectRatio = 0.78,
								}),

								scope:New("UICorner")({
									Name = "UICorner",
								}),

								scope:New("ImageButton")({
									Name = "ImageButton",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									Position = scope:Tween(
										position,
										TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
									),
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Image = "rbxassetid://74641606755800",
									ImageColor3 = BattlePass.RarityColors[value.Rarity],
									ImageTransparency = 0,
									[event("MouseEnter")] = function()
										--scale:set(1.05)
										position:set(UDim2.new(0.5, 0, 0.535, 0))
									end,

									[event("MouseLeave")] = function()
										--scale:set(1)
										position:set(UDim2.new(0.5, 0, 0.5, 0))
									end,

									[event("MouseButton1Down")] = function()
										scale:set(0.9)
									end,

									[event("MouseButton1Up")] = function()

                                        props.OnClaim(key)

                                        scale:set(1)
									end,

									Size = UDim2.fromScale(1, 1),
									[Children] = {
										scope:New("UIScale")({
											Scale = scope:Tween(
												scale,
												TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
											),
										}),

										scope:New("TextLabel")({
											Name = "ClaimText",
                                            Visible = scope:Computed(function(use, scope)

												local claimVis = (not (use(props.PassEXP) < value.RequiredEXP)) and not use(props.Claimed)[key]

												if claimVis then
													(props :: any).AvailableToClaim:set(true)
												end

												return claimVis
                                            end),
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
											Position = UDim2.fromScale(0.499, 0.0958),
											Size = UDim2.fromScale(0.5, 0.201),
											Text = "CLAIM",
											TextColor3 = Color3.fromRGB(255, 255, 255),
											TextScaled = true,
											TextSize = 14,
											TextWrapped = true,
										}),

										scope:New("ImageLabel")({
											Name = "ImageLabel",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Image = value.Image,
											Position = UDim2.fromScale(0.499, 0.497),
											Size = UDim2.fromScale(0.767, 0.598),

											[Children] = {
												scope:New("UIAspectRatioConstraint")({
													Name = "UIAspectRatioConstraint",
												}),
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
											Position = UDim2.fromScale(0.5, 0.856),
											Size = UDim2.fromScale(1, 0.201),
											Text = value.Name,
											TextColor3 = Color3.fromRGB(255, 255, 255),
											TextScaled = true,
											TextSize = 14,
											TextWrapped = true,
										}),

                                        -- progress

                                        scope : New "CanvasGroup" {
                                            Size = UDim2.fromScale(0.8, 0.1),
                                            Position = UDim2.fromScale(0.5, 0.1),
                                            Visible = scope:Computed(function(use, scope)
                                                print(use(props.PassEXP), value.RequiredEXP)
                                                return use(props.PassEXP) < value.RequiredEXP
                                            end),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            [Children] = {
                                                scope : New "UICorner" {
                                                    CornerRadius = UDim.new(0.5, 0),
                                                },
                                                scope : New "Frame" {
                                                    Size = scope:Computed(function(use, scope)
                                                        return UDim2.fromScale(use(props.PassEXP) / value.RequiredEXP, 1)
                                                    end),
                                                    BackgroundColor3 = Color3.fromRGB(55, 232, 255),

                                                },

                                                scope : New "TextLabel" {
                                                    Size = UDim2.fromScale(1, 1),
                                                    Text = scope:Computed(function(use, scope)
                                                        return use(props.PassEXP) .. "/" .. value.RequiredEXP .. " EXP"
                                                    end),
                                                    TextColor3 = Color3.fromRGB(0, 0, 0),
                                                    TextScaled = true,
                                                    Font = Enum.Font.FredokaOne,
                                                    BackgroundTransparency = 1,
                                                }
                                            }
                                        }
									},
								}),

								scope:New("Frame")({
									Name = "Claimed",
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 0.45,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.fromScale(0.997, 0.999),
									Visible = scope:Computed(function(use, scope)
                                        return use(props.Claimed)[key]
                                    end),

                                    [Children] = {
                                        scope:New("ImageLabel")({
                                            Name = "ImageLabel",
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            BackgroundTransparency = 1,
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            Size = UDim2.fromScale(0.25, 0.25),
                                            Image = Icons.CheckMark64,
                                            [Children] = {
                                                scope:New("UIAspectRatioConstraint")({
                                                    AspectRatio = 1,
                                                }),
                                            },
                                        }),
                                    }

								}),


                                scope:New("Frame")({
									Name = "Locked",
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 0.45,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.fromScale(0.997, 0.999),
									Visible = props.Locked,
                                    [Children] = {
                                        scope:New("ImageLabel")({
                                            Name = "ImageLabel",
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            BackgroundTransparency = 1,
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            Size = UDim2.fromScale(0.5, 0.5),
                                            Image = Icons.Lock256,
                                            [Children] = {
                                                scope:New("UIAspectRatioConstraint")({
                                                    AspectRatio = 1,
                                                }),
                                            },
                                        }),
                                    }
								}),

							},
						})
					end),
				},
			}),

			scope:New("UIGradient")({
				Name = "UIGradient",
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.0499, 1),
					NumberSequenceKeypoint.new(0.0898, 0.812),
					NumberSequenceKeypoint.new(0.252, 0),
					NumberSequenceKeypoint.new(0.504, 0),
					NumberSequenceKeypoint.new(0.815, 0.0125),
					NumberSequenceKeypoint.new(0.903, 0.762),
					NumberSequenceKeypoint.new(0.981, 1),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),

			scope:New("UIStroke")({
				Name = "UIStroke",
				Color = Color3.fromRGB(255, 200, 172),
				Thickness = 0,
			}),
		},
	})
end

return PassComponent
