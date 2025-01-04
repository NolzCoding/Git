local Shop = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, peek = Fusion.Children, Fusion.peek
local computed = Fusion.Computed
local forPairs = Fusion.ForPairs
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Item = require(script.Item)
local Sounds = require(ReplicatedStorage.Source.Shared.Sounds)
local SoundService = game:GetService("SoundService")
local Sticker = require(script.Parent.Parent.Parent.Components.UI.Sticker)
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

	self.NonRestricted = scope:Value(false)

	task.spawn(function()

		local info = game:GetService("PolicyService"):GetPolicyInfoForPlayerAsync(game.Players.LocalPlayer)


		if info.ArePaidRandomItemsRestricted then
			self.NonRestricted:set(false)
		else
			self.NonRestricted:set(true)
		end

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

			local contentsOpen = scope:Value(false)

			local contents = scope:Value({})

			local price3 = scope:Value(100)
			local price10 = scope:Value(500)

			local productid1 = 0
			local productid3 = 0
			local productid10 = 0

			local function getNewPrices(crate)

				local price3Info = MarketplaceService:GetProductInfo(RNGData.RNGTableProductsIds[crate][3], Enum.InfoType.Product)

				local price10Info = MarketplaceService:GetProductInfo(RNGData.RNGTableProductsIds[crate][10], Enum.InfoType.Product)

				price3:set(price3Info.PriceInRobux)
				price10:set(price10Info.PriceInRobux)

				productid1 = RNGData.RNGTableProductsIds[crate][1]
				productid3 = RNGData.RNGTableProductsIds[crate][3]
				productid10 = RNGData.RNGTableProductsIds[crate][10]


			end

			scope:Observer(self.ActiveCrate):onChange(function()
				contents:set(RNGData.RNGTable[peek(self.ActiveCrate)])
				getNewPrices(peek(self.ActiveCrate))
			end)

			local contentsWindow = Window(scope, {
				HeaderText = "Contents",
				ZIndex = 6,
				Open = contentsOpen,
				Size = UDim2.fromScale(0.8, 0.8),
				Build = function(scope)

					return scope:New "Frame" {
						ZIndex = 3,
						Size = UDim2.new(0.85, 0, 0.75, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.6, 0),
						BackgroundTransparency = 1,
						[Children] = {

							scope:New "UIGridLayout" {
								CellSize = UDim2.new(0.2, 0, 0.25, 0),
								CellPadding = UDim2.new(0.05, 0, 0.05, 0),
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Top,
							},

							scope : ForPairs(contents, function(use, scope, key, value)

								return key, scope : New "ImageLabel" {

									BackgroundTransparency = 1,
									Image = value.Image,

									[Children] = {

										TextLabelWithStroke(scope, {
											Text = value.Name,
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = UDim2.fromScale(0.5, -0.1),
											Size = UDim2.fromScale(1, 0.2),
											TextColor3 = rarityColors[value.Rarity],
										}),

										TextLabelWithStroke(scope, {
											Text = value.Chance * 100 .. "%",
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = UDim2.fromScale(0.5, 1),
											Size = UDim2.fromScale(1, 0.2),
											TextColor3 = rarityColors[value.Rarity],
										}),

										scope : New  "UIAspectRatioConstraint" {
											AspectRatio = 1,
										}

									}

								}

							end)

						}
					}

				end
			})

			return {
				contentsWindow,
				DefaultButton(scope, {

					Position = UDim2.fromScale(0.1, 0.1),
					Size = UDim2.fromScale(0.15, 0.2),
					ZIndex = 5,

					Text = "See Contents",
					ButtonDown = function()


					end,
					ButtonUp = function()
						contentsOpen:set(not peek(contentsOpen))
					end


				}),

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
											Name = "Buy3",
											Visible = self.NonRestricted,

											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(6, 255, 151),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
											Position = UDim2.fromScale(0.184, 0.5),
											Size = UDim2.fromScale(0.301, 0.564),
											Text = "3x",

											ButtonUp = function()
											end,

											ButtonDown = function()
												MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productid3)
											end,

											Build = function()

												return Sticker(scope, {
													Color = Color3.fromRGB(21, 255, 0),
													Position = UDim2.fromScale(0, 0),
													Size = UDim2.fromScale(0.5, 0.5),
													Text = scope:Computed(function(use, scope)
														return use(price3) .. "R$"
													end),
													AnchorPoint = Vector2.new(0, 1),
												})

											end

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

													MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productid1)

													return
												end

												roll()
											end,

											ButtonDown = function()
											end,

										}),

										DefaultButton(scope,{
											Name = "Buy10",
											Visible = self.NonRestricted,
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(6, 255, 151),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
											Position = UDim2.fromScale(0.823, 0.5),
											Size = UDim2.fromScale(0.301, 0.564),
											Text = "10x",

											ButtonUp = function()

											end,

											ButtonDown = function()
												MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productid10)
											end,

											Build = function()

												return Sticker(scope, {
													Color = Color3.fromRGB(255, 0, 0),
													Position = UDim2.fromScale(0, 0),
													Size = UDim2.fromScale(0.5, 0.5),
													Text = scope:Computed(function(use, scope)
														return use(price10) .. "R$"
													end),
													AnchorPoint = Vector2.new(0, 1),

												})

											end

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
