local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
--local PricingModule = require(ReplicatedStorage.Source.Shared.Pricing)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local RNGData = require(ReplicatedStorage.Source.Shared.RNGData)
local RobuxService = Knit.CreateService{Name = "RobuxService",DataService = nil , Client = { }, GamepassListeners = {}}
local ServerStorage = game:GetService("ServerStorage")
local GameSession = require(ServerStorage.Source.Services.MatchService.GameSession)

function RobuxService:KnitStart()
	self.DataService = Knit.GetService("DataService")
	self.AwardService = Knit.GetService("AwardService")
	self.CharacterService = Knit.GetService("CharacterService")
	self.BattlepassService = Knit.GetService("BattlepassService")
end

function RobuxService:GiveCrate(player, crateName, amount)
	self.AwardService:GiveAward(player, "Crate", crateName, amount)
end

function RobuxService:ReviveBaby(player)

	local gravestonePlayerID = player:GetAttribute("Gravestone")
	local reviveplayer = Players:GetPlayerByUserId(gravestonePlayerID)

	local buyerCharacter = self.CharacterService:GetCharacter(player)
	local GameSession = buyerCharacter.GameSession :: GameSession.GameSession

	local reviveCharacter = self.CharacterService:GetCharacter(reviveplayer)

	GameSession:ReviveBaby(reviveCharacter.Gravestone)

end

function RobuxService:Starterpack(player)
	self.AwardService:GiveAward(player, "Cash", 800)
	self.AwardService:GiveAward(player, "Skin", "Baby", "Scary Noob Baby")
end

function RobuxService:Seasonpass(player)

	local data = self.DataService:GetData(player)


end


--     1908201326,1909998210,1909998515


function RobuxService:KnitInit()


	--1726703382


	-- 2074484794
	-- 2074532799
	-- 2074550316
    local DevpassID = {
		--! eggs

		["SkinCrate1"] = {2689666148, function(plr) return self:GiveCrate(plr, "Skin Crate", 1) end},
		["SkinCrate3"] = {2689667076, function(plr) return self:GiveCrate(plr, "Skin Crate", 3) end},
		["SkinCrate10"] = {2689667404, function(plr) return self:GiveCrate(plr, "Skin Crate", 10) end},

		["AbilityCrate1"] = {2689671243, function(plr) return self:GiveCrate(plr, "Ability Crate", 1) end},
		["AbilityCrate3"] = {2689672250, function(plr) return self:GiveCrate(plr, "Ability Crate", 3) end},
		["AbilityCrate10"] = {2689672655, function(plr) return self:GiveCrate(plr, "Ability Crate", 10) end},

		["EpicSkinCrate1"] = {2689668257, function(plr) return self:GiveCrate(plr, "Epic Skin Crate", 1) end},
		["EpicSkinCrate3"] = {2689668970, function(plr) return self:GiveCrate(plr, "Epic Skin Crate", 3) end},
		["EpicSkinCrate10"] = {2689669692, function(plr) return self:GiveCrate(plr, "Epic Skin Crate", 10) end},

		["Nerd"] = {2688415605, function(plr) return self.AwardService:GiveAward(plr, "Skin", "Baby", "Nerd") end},

		["Skin Pack"] = {2699462245, function(plr)

			self.AwardService:GiveAward(plr, "Skin", "Baby", "Iron Baby")

			self.AwardService:GiveAward(plr, "Skin", "Baby", "Cry Baby")

			self.AwardService:GiveAward(plr, "Skin", "Baby", "Player196")

			self.AwardService:GiveAward(plr, "Skin", "Parent", "Squid Game")


		end},

		["Ability Pack"] = {2699445518, function(plr)

			self.AwardService:GiveAward(plr, "Ability", "Jump", 8)
			self.AwardService:GiveAward(plr, "Ability", "Speed", 5)
			self.AwardService:GiveAward(plr, "Ability", "Invisibility", 2)


		end},

		["Cash500"] = {2689679824, function(plr) return self.AwardService:GiveAward(plr, "Cash", 500) end},
		["Cash5000"] = {2689680885, function(plr) return self.AwardService:GiveAward(plr, "Cash", 5000) end},
		["Cash20000"] = {2689682303, function(plr) return self.AwardService:GiveAward(plr, "Cash", 20000) end},
		["Cash100000"] = {2689682959, function(plr) return self.AwardService:GiveAward(plr, "Cash", 100000) end},

		["ReviveBaby"] = {2695617898, function(plr) return self:ReviveBaby(plr) end},
		--2695770303

		["Starterpack"] = {2695770303, function(plr) return self:Starterpack(plr) end},

		["Season1Pass"] = {2700938303, function(plr) return self.BattlepassService:AddPass(plr, "PremiumPassS1") end}

		-- Robux Egg

		--["Coin1"] = {1740371246, function(plr) return RobuxService:BuyCoinTier(plr, 1) end};
		--["Coin2"] = {1740372042, function(plr) return RobuxService:BuyCoinTier(plr, 2) end};
		--["Coin3"] = {1740373062, function(plr) return RobuxService:BuyCoinTier(plr, 3) end};
		--["Coin4"] = {1740373478, function(plr) return RobuxService:BuyCoinTier(plr, 4) end};
		--["Coin5"] = {1740373879, function(plr) return RobuxService:BuyCoinTier(plr, 5) end};

--1741113328
    }

    local function robux(receiptInfo)
		print("init robyx2")

		local plr = Players:GetPlayerByUserId(receiptInfo.PlayerId)


		if plr and receiptInfo then
			local success = false
			for devProductName, tbl in pairs(DevpassID) do
				if type(tbl) == "table" then
					local id,func = tbl[1],tbl[2]
					if id ~= nil and func ~= nil and type(func) == "function" then
						if receiptInfo.ProductId == id then
							local functionFinised = func(plr)
							if functionFinised == false then
								warn("Something went wrong when", plr.Name, "was buying a developer product!", devProductName)
								success = false
							else


								-- send webhook if you want
								success = true
							end
							break
						end
					end
				end
			end
			if success == true then
				return Enum.ProductPurchaseDecision.PurchaseGranted
			else
				return Enum.ProductPurchaseDecision.NotProcessedYet
			end
		end
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

    MarketplaceService.ProcessReceipt = robux

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)

		if wasPurchased then

			local function run()
				local data = self.DataService:GetData(player)

				table.insert(data.Gamepasses, gamePassId)

				self.DataService:SetData(player, "Gamepasses", data.Gamepasses)

			end

			if not pcall(run) then

				warn("[SERIOUS] there was an issue with processing gamepass id " .. tostring(gamePassId) .. ", with player ".. player.Name .. " with user id " .. tostring(player.UserId))

			end

			if not self.GamepassListeners[tostring(gamePassId)] then return end

			for _, value in ipairs(self.GamepassListeners[tostring(gamePassId)]) do
				value()
			end

		end

	end)


end


return RobuxService