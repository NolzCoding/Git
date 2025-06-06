local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local CalculateLevels = require(ReplicatedStorage.Source.Shared.CalculateLevels)
local Children = Fusion.Children
local TweenService = game:GetService("TweenService")
local value = Fusion.Value
local Toolbar = require(script.Toolbar)
local ItemUi = require(script.ItemUi)
local HealthBar = require(script.HealthBar)
local Winscreen = require(script.Winscreen)
local LoadingScreen = require(script.LoadingScreen)
local LevelBar = require(script.LevelBar)
local PlayerList = require(script.PlayerList)
local TopTimer = require(script.TopTimer)
local QuestUI = require(script.QuestUI)
local Starterpack = require(script.Starterpack)
local PurschaseOverlay = require(script.Parent.Components.UI.PurschaseOverlay)
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
            Open = self.scope:Value(false),
            Module = windowModule,
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

    local MatchService = Knit.GetService("MatchService")
    self.CharacterController = Knit.GetController("CharacterController")
    self.DataService = Knit.GetService("DataService")
    self.DataController = Knit.GetController("DataController")
    self.MusicController = Knit.GetController("MusicController")

    local _ready, data = self.DataService.DataProperty:OnReady():await()


    local cash = self.scope:Value(data.Cash)
    local levels = self.scope:Value(data.Levels)

	self.DataController:OnDataChanged("Cash", function(_cash)
        cash:set(_cash)
    end)

    self.DataController:OnDataChanged("Levels", function(_levels)
        levels:set(_levels)
    end)
    local loadingScreenVisible = self.scope:Value(false)
    local winVisible = self.scope:Value(false)
    local whowon = self.scope:Value("Parents")


    local showTutorial = true

    MatchService.StateSignal:Connect(function(stateName : string, stateText : string, time : number, ...)

        if stateName == "ChoosingMap" then
            print("Opening VoteMap")
            self:OpenWindow("VoteMap")
        elseif stateName == "Loading" then
            self:CloseWindow("VoteMap")
        elseif stateName == "Starting" then
            self.MusicController:PlayCatagory("InGame")
            loadingScreenVisible:set(true)

            task.delay(5, function()
                loadingScreenVisible:set(false)
            end)

            local parents, babies = ...
            parentPlayers:set(parents)
            babyPlayers:set(babies)

            local maybeABabyClass = self.CharacterController:GetCharacter()

            if maybeABabyClass and maybeABabyClass.HighlightHealth then

                maybeABabyClass:HighlightHealth(true)

            end



        else
            loadingScreenVisible:set(false)

            local maybeABabyClass = self.CharacterController:GetCharacter()

            if maybeABabyClass and maybeABabyClass.HighlightHealth then

                task.delay(2, function()

                    maybeABabyClass:HighlightHealth(false)


                end)

            end

            if maybeABabyClass and maybeABabyClass.HighlightBabies then

                maybeABabyClass:HighlightBabies(Fusion.peek(babyPlayers).Alive)

            end

        end

        if stateName == "Playing" then
            if showTutorial then
                self:OpenWindow("Tutorial")
                showTutorial = false
            end
        end

        if stateName == "Ending" then
            local wonTeam = ...
            whowon:set(wonTeam)
            winVisible:set(true)
            self.MusicController:PlayCatagory("Lobby")
            babyPlayers:set({Alive = {}, Dead = {}})
            parentPlayers:set({Alive = {}, Dead = {}})
        else

            winVisible:set(false)

        end

    end)


    MatchService.ScoreSignal:Connect(function(...)
        local parents, babies = ...

        parentPlayers:set(parents)
        babyPlayers:set(babies)

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
            Winscreen(self.scope, {
                WhoWon = whowon,
                Visible = winVisible,
            }),

            LoadingScreen(self.scope, {
                Visible = loadingScreenVisible,
            }),

            Starterpack(self.scope, {}),


            QuestUI(self.scope),

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

                    --[[DefaultButton(self.scope, {
                        Size = UDim2.fromScale(0.2, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 1),
                        ZIndex = 1,
                        Visible = false,
                        Text = "Revive All Players",
                        BackgroundColor3 = Color3.fromRGB(136, 255, 0),
                        StrokeColor3 = Color3.fromRGB(22, 22, 22),
                        ButtonUp = function()
                            print("Button Up")
                        end,
                        ButtonDown = function()
                            print("Button Down")
                        end
                    }),]]

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

            LevelBar(self.scope, {
                Size = UDim2.fromScale(0.52, 0.0485),
                Position = UDim2.fromScale(0.013, 0.106),
                Level = self.scope:Computed(function(use)
                    return use(levels).Level
                end),
                Exp = self.scope:Computed(function(use)
                    return use(levels).Experience
                end),
                NextLevelExp = self.scope:Computed(function(use)
                    return CalculateLevels:GetNextLevelExperience(use(levels).Level)
                end),
                Label = self.scope:Computed(function(use)
                    return CalculateLevels:GetLevelLabel(use(levels).Level)
                end),
            }),

            RightSidebar(self.scope, {
                Cash = cash,
                OpenWindow = function(name : string, ...)

                    self:CloseAllWindows()

                    --[[local window = self.WindowInstances[name]

                    if window then
                        window.Open:set(true)
                    end]]

                    self:OpenWindow(name, ...)

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

function UIController:OpenWindow(name : string, ...)

    local window = self.WindowInstances[name]

    if window then
        window.Open:set(true)
        if window.Module.OnOpen then
            window.Module:OnOpen(...)
        end
    end

    --local Blur = game.Lighting:WaitForChild("Blur") :: BlurEffect
   -- TweenService:Create(Blur, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = 20}):Play()

end

function UIController:CloseWindow(name : string, ...)

    local window = self.WindowInstances[name]

    if window then
        window.Open:set(false)

        if window.Module.OnClose then
            window.Module:OnClose(...)
        end
    end


    --local Blur = game.Lighting:WaitForChild("Blur") :: BlurEffect
    --TweenService:Create(Blur, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = 0}):Play()

end

function UIController:CloseAllWindows()

    for _, window in pairs(self.WindowInstances) do
        window.Open:set(false)
    end

end



return UIController