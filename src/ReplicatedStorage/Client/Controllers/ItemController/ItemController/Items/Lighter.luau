local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local LighterClient = {}
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local Sounds = require(ReplicatedStorage.Source.Shared.Sounds)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)

LighterClient.__index = LighterClient
setmetatable(LighterClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type LighterClient = {
	TestProperty2: string,
} & typeof(setmetatable({}, LighterClient)) & typeof(ItemBase.new())
export type NexusInstanceLighterClient = NexusInstance.NexusInstance<LighterClient>

function LighterClient.__new(self: NexusInstanceLighterClient, itemName: string, tool: Tool, cashedVisual: Model?)
	print("LighterClient")
	ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!

	local lightSound = Instance.new("Sound")
	lightSound.SoundId = Sounds.Lighter.Light
	lightSound.Parent = tool

	local clickSound = Instance.new("Sound")
	clickSound.SoundId = Sounds.Lighter.Click
	clickSound.Parent = tool

	local character = Players.LocalPlayer.Character

	local isBaby = character:GetAttribute("Character") == "Baby"

	if isBaby then
		self.BuildUI = function(scope)
			return ActionButton(scope, {
				Position = UDim2.new(0.8, 0, 0.85, 0),
				Size = UDim2.new(0.1, 0, 0.1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 14, 14),
				ButtonText = "Toggle F",
				KeyCode = Enum.KeyCode.F,
				Image = Icons.Drop,
				ImageSize = UDim2.new(0.5, 0, 0.5, 0),
				ButtonUp = function()
					local particle = self.Tool.FlamePart.Flame1
					local light = self.Tool.FlamePart.PointLight

					particle.Enabled = not particle.Enabled
					light.Enabled = not light.Enabled

					if particle.Enabled then
						lightSound:Play()
					else
						clickSound:Play()
					end

					self.Server:ToggleLighter()
				end,
			})
		end
	end

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			local particle = self.Tool.FlamePart.Flame1
			local light = self.Tool.FlamePart.PointLight

			particle.Enabled = not particle.Enabled
			light.Enabled = not light.Enabled

			if particle.Enabled then
				lightSound:Play()
			else
				clickSound:Play()
			end

			self.Server:ToggleLighter()
		end
	end)

	-- self.Server:DropItem()
end

return NexusInstance.ToInstance(
		LighterClient
	) :: NexusInstance.NexusInstanceClass<
		typeof(LighterClient),
		(Input1: string, Input2: string) -> NexusInstanceLighterClient
	>
