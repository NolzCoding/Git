local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local ServerScriptService = game:GetService("ServerScriptService")
--local PricingModule = require(ReplicatedStorage.Source.Shared.Pricing)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local RobuxService = Knit.CreateService{Name = "RobuxService",DataService = nil , Client = { }, GamepassListeners = {}}



function RobuxService:KnitStart()
	self.DataService = Knit.GetService("DataService")

end





--     1908201326,1909998210,1909998515


function RobuxService:KnitInit()


	--1726703382


	-- 2074484794
	-- 2074532799
	-- 2074550316
    local DevpassID = {
		--! eggs



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