local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.fusion)

local Value, Observer, Computed, ForKeys, ForValues, ForPairs, Hydrate =
	Fusion.Value, Fusion.Observer, Fusion.Computed, Fusion.ForKeys, Fusion.ForValues, Fusion.ForPairs, Fusion.Hydrate
local New, Children, OnEvent, OnChange, Out, Ref, Cleanup =
	Fusion.New, Fusion.Children, Fusion.OnEvent, Fusion.OnChange, Fusion.Out, Fusion.Ref, Fusion.Cleanup
local Tween, Spring = Fusion.Tween, Fusion.Spring

local peek = Fusion.peek
local PurchaseOverlay = {}
local Spinner = require(script.Parent.Spinner)
type UsedAs<T> = Fusion.UsedAs<T>


local function PurchaseOverlay(
	scope: {
        Tween: Tween,
    },
	props: {
        CurrentTime: UsedAs<number>,
        Visible: UsedAs<boolean>,

	})

    local scale = scope:Value(0)

    scope:Observer(props.Visible):onChange(function()

        local visible = peek(props.Visible)

        if visible then
            scale:set(1)
        else
            scale:set(0)
        end

    end)

    return scope:New "Frame" {
        Name = "PurchaseOverlay",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        [Children] = {

            Spinner(scope, {

                Layout = {
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                },
                CurrentTime = props.CurrentTime,

            }),

            scope: New "UIScale" {
                Scale = scope:Tween(scale, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)),
            },

        }

    }


end








return PurchaseOverlay


