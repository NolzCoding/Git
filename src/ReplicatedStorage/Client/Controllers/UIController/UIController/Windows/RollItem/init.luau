local Shop = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, peek = Fusion.Children, Fusion.peek
local computed = Fusion.Computed
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Item = require(script.Item)
local Sounds = require(ReplicatedStorage.Source.Shared.Sounds)
local SoundService = game:GetService("SoundService")
local RNGData = require(ReplicatedStorage.Source.Shared.RNGData)
function Shop:Start() -- knit start

end

local rarityColors = {
	["Common"] = Color3.fromRGB(182, 182, 182),
	["Uncommon"] = Color3.fromRGB(0, 255, 0),
	["Rare"] = Color3.fromRGB(0, 0, 255),
	["Epic"] = Color3.fromRGB(255, 0, 255),
	["Legendary"] = Color3.fromRGB(255, 153, 0),
}

function Shop:OnOpen(...)

	local crate = ...

	print(crate)

	if crate then
		self.ActiveCrate:set(crate)
	end

end

function Shop:OnClose()



end

function Shop:Build(scope: typeof(Fusion.scoped(Fusion)), open)

	local rollSignal = Signal.new()
	local tickSound = Instance.new("Sound")
	tickSound.SoundId = "rbxassetid://9119713951"
	tickSound.Parent = SoundService

	local unlockSound = Instance.new("Sound")
	unlockSound.SoundId = Sounds.UnlockItem
	unlockSound.Parent = SoundService

	self.RNGService = Knit.GetService("RNGService")
	self.NotificationController = Knit.GetController("NotificationController")
	self.DataService = Knit.GetService("DataService")
	self.DataController = Knit.GetController("DataController")
	local ready, data = self.DataService.DataProperty:OnReady():await()

    local crates = scope:Value(data.Inventory.Crates)

	self.DataController:OnDataChanged("Inventory", function(inventory)
        crates:set(inventory.Crates)
    end)



	local rollTable = {
		{
			Name = "Item 1",
			Rarity = "Common",
			Image = Icons.OrganHeart,
			Chance = 0.5,
		},
		{
			Name = "Item 2",
			Rarity = "Uncommon",
			Image = Icons.Rocket,
			Chance = 0.3,
		},
		{
			Name = "Item 3",
			Rarity = "Rare",
			Image = Icons.EmptyHeart,
			Chance = 0.15,
		},
		{
			Name = "Item 4",
			Rarity = "Epic",
			Image = "rbxassetid://127092089997800",
			Chance = 0.04,
		},
		{
			Name = "Item 5",
			Rarity = "Legendary",
			Image = "rbxassetid://127092089997800",
			Chance = 0.01,
		},
	}

	rollTable = RNGData.RNGTable["Starter Crate"]

	self.ActiveCrate = scope:Value("None")




	local display1 = scope:Value({
		Name = "Item 1",
		RarityColor = rarityColors["Common"],
		Image = "rbxassetid://127092089997800",
	})

	local display2 = scope:Value({
		Name = "Item 2",
		RarityColor = rarityColors["Uncommon"],
		Image = "rbxassetid://127092089997800",
	})

	local display3 = scope:Value({
		Name = "Item 3",
		RarityColor = rarityColors["Rare"],
		Image = "rbxassetid://127092089997800",
	})

	scope:Observer(self.ActiveCrate):onChange(function()

		rollTable = RNGData.RNGTable[peek(self.ActiveCrate)]

		-- display random items from new crate

		local display1tbl = rollTable[math.random(1, #rollTable)]
		display1tbl.RarityColor = rarityColors[display1tbl.Rarity]
		local display2tbl = rollTable[math.random(1, #rollTable)]
		display2tbl.RarityColor = rarityColors[display2tbl.Rarity]
		local display3tbl = rollTable[math.random(1, #rollTable)]
		display3tbl.RarityColor = rarityColors[display3tbl.Rarity]

		display1:set(display1tbl)
		display2:set(display2tbl)
		display3:set(display3tbl)

	end)

	local function roll()

		-- check if player has enough crates

		local currentCrate = peek(self.ActiveCrate)
		local crates = peek(crates)

		local curretCrateAmount = crates[currentCrate] or 0

		if curretCrateAmount <= 0 then

			self.NotificationController:TextNImage({
				Text = "You don't have any " .. currentCrate .. " crates",
				Image = Icons.Emojis.Skull,
				Color = Color3.new(1.000000, 0.090196, 0.090196),
				Time = 5,
			})

			return
		end

		-- actuall winning item
		local winningItem = nil
		local roll = math.random()
		local total = 0
		for _, item in ipairs(rollTable) do
			total += item.Chance
			if roll <= total then
				winningItem = item
				break
			end
		end

		print()

		-- create table of filler items to display

		local amountOfFillers = 20

		local fillerItems = {}

		for i = 1, amountOfFillers do
			local fillerItem = rollTable[math.random(1, #rollTable)]
			fillerItems[#fillerItems + 1] = fillerItem
		end



		-- insert winning item in index 2

		self.RNGService:OpenCrate(Fusion.peek(self.ActiveCrate)):andThen(function(item)
			winningItem = item

			winningItem.RarityColor = rarityColors[winningItem.Rarity]
			table.insert(fillerItems, 2, winningItem)
			print(" you won...",winningItem)

		end)




		-- animate the roll

		local middleIndex = 19

		for i = 20, 3, -1 do


			local display1Index = middleIndex - 1
			local display3Index = middleIndex + 1

			if display1Index < 1 then
				display1Index = #fillerItems
			end

			if display3Index > #fillerItems then
				display3Index = 1
			end

			local display1tbl = fillerItems[display1Index]
			display1tbl.RarityColor = rarityColors[display1tbl.Rarity]
			local display2tbl = fillerItems[middleIndex]
			display2tbl.RarityColor = rarityColors[display2tbl.Rarity]
			local display3tbl = fillerItems[display3Index]
			display3tbl.RarityColor = rarityColors[display3tbl.Rarity]

			print(display1tbl)

			display1:set(display1tbl)
			display2:set(display2tbl)
			display3:set(display3tbl)

			rollSignal:Fire()
			middleIndex += -1

			SoundService:PlayLocalSound(tickSound)
			-- fast at the start, slow at the end
			task.wait(0.3 - (i * 0.01))
		end


		self.NotificationController:TextNImage({
			Text = "x1 " .. winningItem.Rarity .. " " .. winningItem.Name,
			Image = winningItem.Image,
			Color = rarityColors[winningItem.Rarity],
			Time = 5,
		})

		-- unlock the item
		unlockSound:Play()

	end

	local indexFromValue = function(scope, value, index)

		return scope:Computed(function(use, scope)
			print(use(value)[index])
			return use(value)[index]
		end)

	end

	return Window(scope, {
		HeaderText = self.ActiveCrate,
		Size = UDim2.fromScale(0.5, 0.5),
		Open = open,
		Build = function(scope)
			return {

				scope:New("Frame")({
					Name = "2",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.498, 0.427),
					Size = UDim2.fromScale(1, 1),
					ZIndex = 4,

					[Children] = {
						scope:New("Frame")({
							Name = "Frame",
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 0.534),
							Size = UDim2.fromScale(1,1),

							[Children] = {
								scope:New("UICorner")({
									Name = "UICorner",
								}),

								scope:New("Frame")({
									Name = "RollOptions",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(34, 34, 34),
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.fromScale(0.5, 0.823),
									Size = UDim2.fromScale(0.825, 0.222),

									[Children] = {
										DefaultButton(scope,{
											Name = "Buy1",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(6, 255, 151),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
											Position = UDim2.fromScale(0.184, 0.5),
											Size = UDim2.fromScale(0.301, 0.564),
											Text = "Buy 1",

											ButtonUp = function()
											end,

											ButtonDown = function()
											end,

										}),

										DefaultButton(scope,{
											Name = "Roll",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(6, 255, 151),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
											Position = UDim2.fromScale(0.501, 0.502),
											Size = UDim2.fromScale(0.301, 0.729),
											Text = "Roll",
											TextScaled = true,
											TextSize = 14,
											TextWrapped = true,
											ButtonUp = function()

												local currentCrate = peek(self.ActiveCrate)
												local crates = peek(crates)
												local curretCrateAmount = crates[currentCrate] or 0

												if curretCrateAmount <= 0 then

													self.NotificationController:TextNImage({
														Text = "You don't have any " .. currentCrate .. " crates",
														Image = Icons.Emojis.Skull,
														Color = Color3.new(1.000000, 0.133333, 0.133333),
														Time = 5,
													})

													return
												end

												roll()
											end,

											ButtonDown = function()
											end,

										}),

										DefaultButton(scope,{
											Name = "Buy3",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(6, 255, 151),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
											Position = UDim2.fromScale(0.823, 0.5),
											Size = UDim2.fromScale(0.301, 0.564),
											Text = "Buy 3",

											ButtonUp = function()
											end,

											ButtonDown = function()
											end,

										}),

										scope:New("UICorner")({
											Name = "UICorner",
										}),
									},
								}),

								scope:New("Frame")({
									Name = "RollArea",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.fromScale(0.5, 0.494),
									Size = UDim2.fromScale(0.825, 0.436),

									[Children] = {

										Item(scope, { -- display 1
											Name = indexFromValue(scope, display1, "Name"),
											RarityColor = indexFromValue(scope, display1, "RarityColor"),
											Image = indexFromValue(scope, display1, "Image"),
											Position = UDim2.fromScale(0.1, 0.58),
											Size = UDim2.fromScale(0.457, 0.843),
											RollSignal = rollSignal,
											OffsetTiming = 0

										}),

										Item(scope, { -- display 2, aka the middle one that is the main item
											Name = indexFromValue(scope, display2, "Name"),
											RarityColor = indexFromValue(scope, display2, "RarityColor"),
											Image = indexFromValue(scope, display2, "Image"),
											Position = UDim2.fromScale(0.5, 0.427),
											Size = UDim2.fromScale(0.457, 1.15),
											RollSignal = rollSignal,
											OffsetTiming = 0.1

										}),

										Item(scope, { -- display 3
											Name = indexFromValue(scope, display3, "Name"),
											RarityColor = indexFromValue(scope, display3, "RarityColor"),
											Image = indexFromValue(scope, display3, "Image"),
											Position = UDim2.fromScale(0.9, 0.58),
											Size = UDim2.fromScale(0.457, 0.843),
											RollSignal = rollSignal,
											OffsetTiming = 0.2


										})

									}

								}),


							},
						}),
					},
				}),
			}
		end,
	})
end

return Shop
