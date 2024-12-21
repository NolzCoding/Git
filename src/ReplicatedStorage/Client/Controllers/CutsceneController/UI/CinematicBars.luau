local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.fusion)

local Value, Observer, Computed, ForKeys, ForValues, ForPairs =
	Fusion.Value, Fusion.Observer, Fusion.Computed, Fusion.ForKeys, Fusion.ForValues, Fusion.ForPairs
local New, Children, OnEvent, OnChange, Out, Ref, Cleanup =
	Fusion.New, Fusion.Children, Fusion.OnEvent, Fusion.OnChange, Fusion.Out, Fusion.Ref, Fusion.Cleanup
local Tween, Spring = Fusion.Tween, Fusion.Spring

local peek = Fusion.peek

local CinematicBars = {}

type UsedAs<T> = Fusion.UsedAs<T>


local function CinematicBars(
	scope: {
        Tween: Tween,
    },
	props: {
		--Position: UsedAs<UDim2>?,
        Visible : UsedAs<boolean>?,
	})

    return scope: New "Frame" {
        Size = UDim2.new(1, 0, 1, 0),
        IgnoreGuiInset = true,
        ZIndex = 0,
        BackgroundTransparency = 1,
        [Children] = {

            scope:New "Frame" {
                Name = "CinematicBarTop",
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(0.5, 1),

                Position = scope:Tween(
                    scope:Computed(function(use)
                        local visible = use(props.Visible)
                        if visible then
                            return UDim2.new(0.5, 0, 0.1, 0)
                        else
                            return UDim2.new(0.5, 0, -0.1, 0)
                        end
                    end), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
            },

            scope:New "Frame" {
                Name = "CinematicBarBottom",
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(0.5, 0),
                Position = scope:Tween(
                    scope:Computed(function(use)
                        local visible = use(props.Visible)
                        if visible then
                            return UDim2.new(0.5, 0, 0.9, 0)
                        else
                            return UDim2.new(0.5, 0, 1.1, 0)
                        end
                    end), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
            }

        }
    }

end

return CinematicBars


