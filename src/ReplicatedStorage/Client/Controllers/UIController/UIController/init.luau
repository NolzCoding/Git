local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local value = Fusion.Value
local Toolbar = require(script.Toolbar)
local ItemUi = require(script.ItemUi)
local HealthBar = require(script.HealthBar)
local PlayerList = require(script.PlayerList)
local TopTimer = require(script.TopTimer)
local RightSidebar = require(script.RightSidebar)
local DefaultButton = require(script.Parent.Components.Buttons.DefaultButton)
local UIController = Knit.CreateController {
    Name = "UIController";
}

type UsedAs<T> = {
    set : (T) -> (),
}

function UIController:KnitInit()

    local scope = Fusion.scoped(Fusion)
    self.scope = scope

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    self.bindedUI = scope:Value({})
    self.WindowInstances = {

    } :: {string : {
        Build : Frame,
        Open : UsedAs<boolean>,
    }}

end

function UIController:BuildWindows()
    print("Building all windows")
    local windows = script.Windows

    local builds = {}

    for _, window in ipairs(windows:GetChildren()) do
        local windowModule = require(window)

        windowModule:Start()

        local windowInstance = {
            Open = self.scope:Value(false)
        }

        windowInstance.Build = windowModule:Build(self.scope, windowInstance.Open)

        table.insert(builds, windowInstance.Build)

        self.WindowInstances[window.Name] = windowInstance

    end

    return builds

end

function UIController:KnitStart()

    local babyPlayers = self.scope:Value({Alive = {}, Dead = {}})
    local parentPlayers = self.scope:Value({Alive = {}, Dead = {}})

    local GameService = Knit.GetService("GameService")

    GameService.StateSignal:Connect(function(stateName : string, stateText : string, time : number, ...)

        if stateName == "GameStart" then

            local parents, babies = ...

            parentPlayers:set(parents)
            babyPlayers:set(babies)
        end

    end)

    self.scope:New "ScreenGui" {
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        Name = "MainUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        [Children] = {
            --Toolbar(scope, {}),
            --ItemUi(scope, {}),
           -- HealthBar(scope, {}),

            self.scope:New "Frame" {
                Name = "Frame",
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.0239),
                Size = UDim2.fromScale(0.436, 0.155),
                [Children] = {

                    self.scope : New "UIAspectRatioConstraint" {
                        AspectRatio = 6,
                    },

                    TopTimer(self.scope, {
                        Position = UDim2.new(0.5, 0, 0.05, 0),
                        AnchorPoint = Vector2.new(0.5, 0),
                        Size = UDim2.new(0.5, 0, 0.7, 0),
                        AspectRatio = 2.5,
                    }),

                    DefaultButton(self.scope, {
                        Size = UDim2.fromScale(0.2, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 1),
                        ZIndex = 1,
                        Text = "Revive All Players",
                        BackgroundColor3 = Color3.fromRGB(136, 255, 0),
                        StrokeColor3 = Color3.fromRGB(22, 22, 22),
                        ButtonUp = function()
                            print("Button Up")
                        end,
                        ButtonDown = function()
                            print("Button Down")
                        end
                    }),

                    PlayerList(self.scope, {
                        Position = UDim2.new(0.3, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Size = UDim2.new(0.4, 0, 1, 0),
                        Players = parentPlayers,
                        Color = Color3.fromRGB(255, 71, 71),
                        HorizontalAlignment = Enum.HorizontalAlignment.Right
                    }),

                    PlayerList(self.scope, {
                        Position = UDim2.new(0.7, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Size = UDim2.new(0.4, 0, 1, 0),
                        Players = babyPlayers,
                        Color = Color3.fromRGB(71, 114, 255),
                        HorizontalAlignment = Enum.HorizontalAlignment.Left
                    }),



                }
              },

            RightSidebar(self.scope, {
                OpenWindow = function(name : string)
                    local window = self.WindowInstances[name]

                    if window then
                        window.Open:set(true)
                    end
                end
            }),

            self.scope:ForValues(self.bindedUI, function(use, scope, tbl)

                return tbl.Build(scope)

            end),

            (function ()

                return self:BuildWindows()

            end)()


        }
    }

end


function UIController:BindUi(name : string, build : () -> (), unbind : () -> ())

    local tbl = {
        Name = name,
        Build = build,
        Unbind = unbind
    }

    local binded = Fusion.peek(self.bindedUI)

    binded[name] = tbl

    self.bindedUI:set(binded)

end

function UIController:UnBindUi(name : string)

    local binded = Fusion.peek(self.bindedUI)

    local tbl = binded[name]

    if tbl then
        tbl.Unbind()
        binded[name] = nil
        self.bindedUI:set(binded)
    else
        warn("UIController:UnBindUi: ", name, " not found")
    end

end

function UIController:OpenWindow(name : string)

    local window = self.WindowInstances[name]

    if window then
        window.Open:set(true)
    end

end

function UIController:CloseWindow(name : string)

    local window = self.WindowInstances[name]

    if window then
        window.Open:set(false)
    end

end

function UIController:CloseAllWindows()

    for _, window in pairs(self.WindowInstances) do
        window.Open:set(false)
    end

end



return UIController