local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local NexusInstance = require(game:GetService("ReplicatedStorage").Source.Shared.Uitility.NexusInstance)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Maps = require(ReplicatedStorage.Source.Shared.Maps)
local SpawnItems = require(ServerStorage.Source.Services.InteractServices.ItemService.SpawnItems)

local DefaultSession = {}
DefaultSession.__index = DefaultSession

local GameSession = require(script.Parent.Parent.GameSession)

setmetatable(DefaultSession, GameSession) --TestClass1NexusInstance would be returned instead of TestClass1.

export type DefaultSession = {

	HandleGame: (self: NexusInstanceDefaultSession, callback: () -> any) -> (),
	StartBabyBucks: () -> (),
	BabyBucksFolder: Folder,
	SpawnItem: (self: NexusInstanceDefaultSession, itemName: string) -> (),
	BabyBuckPromise: Promise,
	Trove: typeof(Trove.new()),
	HandleStates: (self: NexusInstanceDefaultSession) -> (),
	States: {
		ChoosingMap: (
			slot: Part,
			votingTable: { [number]: { Name: string, Image: string, Players: { Player } } }
		) -> Model,
		Loading: (map: Model) -> (),
		Starting: () -> (),
		Playing: () -> (),
		Ending: (winningTeam: { Alive: { Player }, Dead: { Player } }) -> (),
		Cleanup: () -> (),
	},
	Parents: {

		Alive: { Player },
		Dead: { Player },
	},
	Babies: {

		Alive: { Player },
		Dead: { Player },
	},
} & typeof(setmetatable({}, DefaultSession)) & GameSession.GameSession
export type NexusInstanceDefaultSession = NexusInstance.NexusInstance<DefaultSession>

function DefaultSession.__new(self: NexusInstanceDefaultSession, players: { Player })
    print("MAKING NEW SESSION")
	GameSession.__new(self, players) --Remember to call the parent constructor!
    self.States = {}
	self.DataService = Knit.GetService("DataService")
	self.AwardService = Knit.GetService("AwardService")
	self.LevelService = Knit.GetService("LevelService")
	self.Trove = Trove.new()
	self.Parents = {
		Alive = {},
		Dead = {},
	}
	self.Babies = {
		Alive = {},
		Dead = {},
	}
	self:HandleStates()
end

function DefaultSession:SpawnPlayer(player: Player, spawnPoint: Part, characterType: string): ()
	player:AddTag("InGame")
	if player.Character then
		player.Character:Destroy()
	end

	local sucess = pcall(function()
		player:LoadCharacter()
	end)

	if not sucess then
		task.delay(1, function()
			self:SpawnPlayer(player, spawnPoint, characterType)
		end)

		return
	end

	local newChar = self.CharacterService:NewCharacter(player, characterType)
	newChar.GameSession = self

	task.defer(function()
		local character = player.Character
		local root = character:WaitForChild("HumanoidRootPart")
		root.CFrame = spawnPoint.CFrame + Vector3.new(0, 5, 0)
	end)
end

function DefaultSession.ReviveBaby(self: NexusInstanceDefaultSession, graveStone: BasePart)
	-- remove from dead and add to alive

	local player = Players:GetPlayerByUserId(graveStone:GetAttribute("PlayerID"))

	table.remove(self.Babies.Dead, table.find(self.Babies.Dead, player))
	table.insert(self.Babies.Alive, player)

	-- revive the player

	GameSession.ReviveBaby(self, graveStone)
end

function DefaultSession.StartBabyBucks(self: NexusInstanceDefaultSession)
	local babybuck = script.Parent.BabyBuck

	local function _spawnBabyBucks()
		for _, v in ipairs(self.BabyBucksFolder:GetChildren()) do
			local maxBabyBucks = v:GetAttribute("Max") or 1 :: number
			if #v:GetChildren() == maxBabyBucks then
				continue
			end

			local newBabyBuck = babybuck:Clone()
			newBabyBuck.Parent = v

			local randomPosBySize = Vector3.new(
				math.random(-v.Size.X / 2, v.Size.X / 2),
				math.random(-v.Size.Y / 2, v.Size.Y / 2),
				math.random(-v.Size.Z / 2, v.Size.Z / 2)
			)
			newBabyBuck.Position = v.Position + randomPosBySize

			local debounce = false

			newBabyBuck.Touched:Connect(function(part: BasePart)
				if part.Name ~= "HumanoidRootPart" then
					return
				end
				if debounce then
					return
				end

				local player = Players:GetPlayerFromCharacter(part.Parent)
				if not player then
					return
				end

				debounce = true

				local playerTeam = player.Team
				if playerTeam == self.ParentTeam then
					--return
				end

				newBabyBuck:Destroy()

				self.AwardService:GiveAward(player, "Cash", 15)
				--self.LevelService:AwardExperience(player, 10)
			end)
		end
	end

	self.BabyBuckPromise = Promise.new(function(resolve, reject)
		local TIME = 20

		while true do
			print("Spawning")
			_spawnBabyBucks()

			task.wait(TIME)
		end
	end)
end

function DefaultSession.SpawnItem(self: NexusInstanceDefaultSession, itemName: string): ()
	print("Spawning item " .. itemName)
	return SpawnItems:SpawnIndividualItem(itemName, self.Map, Maps.ItemSpawns[self.Map.Name], 1)
end

function DefaultSession.HandleStates(self: NexusInstanceDefaultSession): ()
	self.States.ChoosingMap = function(
		slot: Part,
		votingTable: { [number]: { Name: string, Image: string, Players: { Player } } }
	): Model
		self.OnStateUpdate:Fire("ChoosingMap", "Choosing map", workspace:GetServerTimeNow() + 10)

		self.OnVoteUpdate:Fire(votingTable, workspace:GetServerTimeNow() + 10)

		local playerVote = self.OnPlayerVote:Connect(function(player: Player, id: number)
			-- remove old vote

			for _, v in ipairs(votingTable) do
				local isvoted = table.find(v.Players, player)
				if not isvoted then
					continue
				end
				table.remove(v.Players, isvoted)
			end

			local map = votingTable[id]
			table.insert(map.Players, player)
			print("Inserted player")
			self.OnVoteUpdate:Fire(votingTable)
		end)

		task.wait(10)
		playerVote:Disconnect()

		local highestVotes = 0
		local highestVotedMap = nil

		for _, v in ipairs(votingTable) do
			if #v.Players > highestVotes then
				highestVotes = #v.Players
				highestVotedMap = v
			end
		end

		if highestVotedMap == nil then
			highestVotedMap = votingTable[math.random(1, #votingTable)]
		end

		local map = ServerStorage:FindFirstChild(highestVotedMap.Name) :: Model
		return map
	end

	self.States.Loading = function(map: Model): ()
		self.OnStateUpdate:Fire("Loading", "Loading map", workspace:GetServerTimeNow() + 5)
		local cloneMap = map:Clone()
		cloneMap.Parent = self.GameSlot
		cloneMap:PivotTo(self.GameSlot.CFrame)
		self.Map = cloneMap

		self.BabyBucksFolder = self.Map:WaitForChild("BabyBucks") :: Folder
	end

	self.States.Starting = function(): ()
		local parentSize = 1
		if #self.Players >= 4 then
			parentSize = 2
		end

		-- pickout random players for team 1

		local copyPlayers = table.clone(self.Players)

		for i = 1, parentSize do
			local player = table.remove(copyPlayers, math.random(1, #copyPlayers))
			table.insert(self.Parents.Alive, player)
		end

		-- add the rest of the players to team 2

		for _, player in ipairs(copyPlayers) do
			table.insert(self.Babies.Alive, player)
		end

		-- spawn players

		for _, player in ipairs(self.Babies.Alive) do
			self:SpawnPlayer(player, self.Map.Spawns.Babies, "Baby")
		end

		for _, player in ipairs(self.Parents.Alive) do
			self:SpawnPlayer(player, self.Map.Spawns.Parents, "Parent")
		end

		print(self.Parents, self.Babies, " teams")

		print(self.Parents, self.Babies)
		self.OnStateUpdate:Fire(
			"Starting",
			"Starting game",
			workspace:GetServerTimeNow() + 5,
			self.Parents,
			self.Babies
		)

		task.wait(5)

		local mapName = self.Map.Name

		SpawnItems:NewSpawn(self.Map, Maps.ItemSpawns[mapName])
	end

	self.States.Playing = function(): ()
		self.OnStateUpdate:Fire("Playing", "Playing", workspace:GetServerTimeNow() + 160)

		local GAME_TIME = 160
		local winner = nil

		local _worked, teamWon = Promise.new(function(resolve, reject)
			local alreadyEnded = false

			local function babyDied(player)
				print(alreadyEnded)
				if alreadyEnded then
					return
				end

				-- check if its already dead
				local isDead = table.find(self.Babies.Dead, player)

				if isDead then
					return
				end

				table.remove(self.Babies.Alive, table.find(self.Babies.Alive, player))

				table.insert(self.Babies.Dead, player)

				task.delay(0.1, function()
					if #self.Babies.Alive < #self.Parents.Alive then
						alreadyEnded = true
						resolve(self.Babies)
					end
				end)

				self.OnScoreUpdate:Fire(self.Parents, self.Babies)

				-- spawn as a ghost

				-- destory old character

				local rootCFrame = self.Map.Spawns.Babies.CFrame + Vector3.new(0, 5, 0)

				if player.Character then
					rootCFrame = player.Character.HumanoidRootPart.CFrame
					player.Character:Destroy()
				end

				task.wait()
				player:LoadCharacter()
				local ghostchar = self.CharacterService:NewCharacter(player, "Ghost")

				local newCharacter = player.Character
				local root = newCharacter:WaitForChild("HumanoidRootPart")
				root.CFrame = rootCFrame

				ghostchar:SpawnGravestone(newCharacter)
			end

			for _, v in ipairs(self.Babies.Alive) do
				task.spawn(function()
					local healthAttributeNames = {
						"Lungs",
						"Heart",
						"Stomach",
					}

					local character = v.Character or v.CharacterAdded:Wait()

					local humanoid = v.Character.Humanoid :: Humanoid

					for _, healthAttributeName in ipairs(healthAttributeNames) do
						self.Trove:Connect(humanoid:GetAttributeChangedSignal(healthAttributeName), function()
							if humanoid:GetAttribute(healthAttributeName) <= 0 then
								babyDied(v)
							end
						end)
					end

					self.Trove:Connect(v.Character.Humanoid.Died, function()
						babyDied(v)
					end)

					-- if leaves game


					self.Trove:Connect(Players.PlayerRemoving, function(player: Player)
						if player == v then
							-- check if he's the only one left, since babies should not win if they leave
							print("Player leaving")
                            if not table.find(self.Players, player) then
                                return
                            end

							print("Player leaving2")


							if (#self.Babies.Alive - 1) < #self.Parents.Alive then
								print("Calling Parents won")
								alreadyEnded = true
								resolve(self.Parents)
								return
							end

							babyDied(v)
						end
					end)
				end)

				-- dead = when humanoid dies or when any of the 3 healthAttributes reach 0
			end

			self:StartBabyBucks()

			local parentDiedOrLeft = function(player)
				if alreadyEnded then
					return
				end

				local isDead = table.find(self.Parents.Dead, player)

				if isDead then
					return
				end

				table.remove(self.Parents.Alive, table.find(self.Parents.Alive, player))

				table.insert(self.Parents.Dead, player)

				task.delay(1, function()
					if #self.Parents.Alive == 0 then
						if alreadyEnded then
							return
						end
						print("Calling died from parents")
						resolve(self.Babies)
					end
				end)

				self.OnScoreUpdate:Fire(self.Parents, self.Babies)

				-- spawn as a ghost

				-- destory old character
			end

			for _, player in ipairs(self.Parents.Alive) do
				task.spawn(function()
					local character = player.Character or player.CharacterAdded:Wait()
					--local humanoid = character:WaitForChild("Humanoid") :: Humanoid

					self.Trove:Connect(Players.PlayerRemoving, function(player: Player)

                        -- check if player is in this session
                        if not table.find(self.Players, player) then
                            return
                        end

						parentDiedOrLeft(player)
					end)
				end)
			end

			while GAME_TIME > 0 do
				task.wait(1)
				GAME_TIME -= 1
			end
			resolve(self.Parents)
		end):await()

		-- while GAME_TIME > 0 do
		--    task.wait(1)
		--    GAME_TIME -= 1
		--end

		winner = teamWon or self.Parents

		return winner

		-- returns the winner team
	end

	self.States.Ending = function(winningTeam: { Alive: { Player }, Dead: { Player } }): ()
		local winningteamname = "Parents"
		print(winningTeam == self.Babies, "Did babies win?")
		if winningTeam == self.Babies then
			winningteamname = "Babies"
		end

		for _, player in ipairs(self.Players) do
			player:RemoveTag("InGame")
		end
		self.OnStateUpdate:Fire("Ending", "Ending", workspace:GetServerTimeNow() + 5, winningteamname)

		-- add + win

		task.spawn(function()
			for _, player in ipairs(winningTeam.Alive) do
				local data = self.DataService:GetData(player)
				data.Wins += 1
				self.LevelService:AwardExperience(player, 50, true, " For winning")
				self.AwardService:GiveAward(player, "Cash", 100)
				self.DataService:SetData(player, data)
			end

			for _, player in ipairs(winningTeam.Dead) do
				local data = self.DataService:GetData(player)
				data.Wins += 1
				self.LevelService:AwardExperience(player, 50, true, " For winning")
				self.AwardService:GiveAward(player, "Cash", 100)
				self.DataService:SetData(player, data)
			end

			local losingTeam = winningTeam == self.Babies and self.Parents or self.Babies

			for _, player in ipairs(losingTeam.Alive) do
				self.LevelService:AwardExperience(player, 25, true, " For losing")
				self.AwardService:GiveAward(player, "Cash", 50)
			end

			for _, player in ipairs(losingTeam.Dead) do
				self.LevelService:AwardExperience(player, 25, true, " For losing")
				self.AwardService:GiveAward(player, "Cash", 50)
			end
		end)

		task.wait(5)
	end

	self.States.Cleanup = function(): ()
		if self.BabyBuckPromise then
			self.BabyBuckPromise:cancel()
		end
		self.Map:Destroy()

		for _, player in ipairs(self.Players) do
			player:RemoveTag("InGame")
		end

		self.Parents = nil
		self.Babies = nil

		self.OnStateUpdate:Fire("Cleanup", "Cleanup", workspace:GetServerTimeNow() + 5)
	end
end

--[[function DefaultSession.States.ChoosingMap(
	self: NexusInstanceDefaultSession,
	slot: Part,
	votingTable: { [number]: { Name: string, Image: string, Players: { Player } } }
): Model
	self.OnStateUpdate:Fire("ChoosingMap", "Choosing map", workspace:GetServerTimeNow() + 10)

	self.OnVoteUpdate:Fire(votingTable, workspace:GetServerTimeNow() + 10)

	local playerVote = self.OnPlayerVote:Connect(function(player: Player, id: number)
		-- remove old vote

		for _, v in ipairs(votingTable) do
			local isvoted = table.find(v.Players, player)
			if not isvoted then
				continue
			end
			table.remove(v.Players, isvoted)
		end

		local map = votingTable[id]
		table.insert(map.Players, player)
		print("Inserted player")
		self.OnVoteUpdate:Fire(votingTable)
	end)

	task.wait(10)
	playerVote:Disconnect()

	local highestVotes = 0
	local highestVotedMap = nil

	for _, v in ipairs(votingTable) do
		if #v.Players > highestVotes then
			highestVotes = #v.Players
			highestVotedMap = v
		end
	end

	if highestVotedMap == nil then
		highestVotedMap = votingTable[math.random(1, #votingTable)]
	end

	local map = ServerStorage:FindFirstChild(highestVotedMap.Name) :: Model
	return map
end

function DefaultSession.States.Loading(self: NexusInstanceDefaultSession, map: Model): ()
	self.OnStateUpdate:Fire("Loading", "Loading map", workspace:GetServerTimeNow() + 5)
	local cloneMap = map:Clone()
	cloneMap.Parent = self.GameSlot
	cloneMap:PivotTo(self.GameSlot.CFrame)
	self.Map = cloneMap

	self.BabyBucksFolder = self.Map:WaitForChild("BabyBucks") :: Folder
end

function DefaultSession.States.Starting(self: NexusInstanceDefaultSession): ()
	local parentSize = 1
	if #self.Players >= 4 then
		parentSize = 2
	end

	-- pickout random players for team 1

	local copyPlayers = table.clone(self.Players)

	for i = 1, parentSize do
		local player = table.remove(copyPlayers, math.random(1, #copyPlayers))
		table.insert(self.Parents.Alive, player)
	end

	-- add the rest of the players to team 2

	for _, player in ipairs(copyPlayers) do
		table.insert(self.Babies.Alive, player)
	end

	-- spawn players

	for _, player in ipairs(self.Babies.Alive) do
		self:SpawnPlayer(player, self.Map.Spawns.Babies, "Baby")
	end

	for _, player in ipairs(self.Parents.Alive) do
		self:SpawnPlayer(player, self.Map.Spawns.Parents, "Parent")
	end
	print(self.Parents, self.Babies)
	self.OnStateUpdate:Fire("Starting", "Starting game", workspace:GetServerTimeNow() + 5, self.Parents, self.Babies)

	task.wait(5)

	local mapName = self.Map.Name

	SpawnItems:Spawn(self.Map, Maps.ItemSpawns[mapName])
end]]

function DefaultSession.HandleGame(
	self: NexusInstanceDefaultSession,
	callback: () -> any,
	parentsWonCallback: () -> any
): ()
	local alreadyEnded = false

	local function babyDied(player)
		print(alreadyEnded)
		if alreadyEnded then
			return
		end

		-- check if its already dead
		local isDead = table.find(self.Babies.Dead, player)

		if isDead then
			return
		end

		table.remove(self.Babies.Alive, table.find(self.Babies.Alive, player))

		table.insert(self.Babies.Dead, player)

		task.delay(0.1, function()
			if #self.Babies.Alive == 0 then
				alreadyEnded = true
				callback()
			end
		end)

		self.OnScoreUpdate:Fire(self.Parents, self.Babies)

		-- spawn as a ghost

		-- destory old character

		local rootCFrame = self.Map.Spawns.Babies.CFrame + Vector3.new(0, 5, 0)

		if player.Character then
			rootCFrame = player.Character.HumanoidRootPart.CFrame
			player.Character:Destroy()
		end

		task.wait()
		player:LoadCharacter()
		local ghostchar = self.CharacterService:NewCharacter(player, "Ghost")

		local newCharacter = player.Character
		local root = newCharacter:WaitForChild("HumanoidRootPart")
		root.CFrame = rootCFrame

		ghostchar:SpawnGravestone(newCharacter)
	end

	for _, v in ipairs(self.Babies.Alive) do
		task.spawn(function()
			local healthAttributeNames = {
				"Lungs",
				"Heart",
				"Stomach",
			}

			local character = v.Character or v.CharacterAdded:Wait()

			local humanoid = v.Character.Humanoid :: Humanoid

			for _, healthAttributeName in ipairs(healthAttributeNames) do
				self.Trove:Connect(humanoid:GetAttributeChangedSignal(healthAttributeName), function()
					if humanoid:GetAttribute(healthAttributeName) <= 0 then
						babyDied(v)
					end
				end)
			end

			self.Trove:Connect(v.Character.Humanoid.Died, function()
				babyDied(v)
			end)

			-- if leaves game

			self.Trove:Connect(Players.PlayerRemoving, function(player: Player)
				if player == v then
					-- check if he's the only one left, since babies should not win if they leave
                    -- check if he's in the session
                    if not table.find(self.Players, player) then
                        return
                    end
					if #self.Babies.Alive == 1 then
						print("Calling Parents won")
						alreadyEnded = true
						parentsWonCallback()
						return
					end

					babyDied(v)
				end
			end)
		end)

		-- dead = when humanoid dies or when any of the 3 healthAttributes reach 0
	end

	self:StartBabyBucks()

	local parentDiedOrLeft = function(player)
		if alreadyEnded then
			return
		end

		local isDead = table.find(self.Parents.Dead, player)

		if isDead then
			return
		end

		table.remove(self.Parents.Alive, table.find(self.Parents.Alive, player))

		table.insert(self.Parents.Dead, player)

		task.delay(1, function()
			if #self.Parents.Alive == 0 then
				if alreadyEnded then
					return
				end
				print("Calling died from parents")
				callback()
			end
		end)

		self.OnScoreUpdate:Fire(self.Parents, self.Babies)

		-- spawn as a ghost

		-- destory old character
	end

	for _, player in ipairs(self.Parents.Alive) do
		task.spawn(function()
			local character = player.Character or player.CharacterAdded:Wait()
			--local humanoid = character:WaitForChild("Humanoid") :: Humanoid

			self.Trove:Connect(Players.PlayerRemoving, function(player: Player)

                -- check if player is in this session
                if not table.find(self.Players, player) then
                    return
                end

				parentDiedOrLeft(player)
			end)
		end)
	end
end

--[[function DefaultSession.States.Playing(self: NexusInstanceDefaultSession): ()
	self.OnStateUpdate:Fire("Playing", "Playing", workspace:GetServerTimeNow() + 160)

	local GAME_TIME = 160
	local winner = nil

	local function allBabiesDeadCallback()
		winner = self.Babies
		GAME_TIME = 0
	end

	self:HandleGame(allBabiesDeadCallback)

	while GAME_TIME > 0 do
		task.wait(1)
		GAME_TIME -= 1
	end

	winner = winner or self.Parents

	return winner

	-- returns the winner team
end

function DefaultSession.States.Ending(
	self: NexusInstanceDefaultSession,
	winningTeam: { Alive: { Player }, Dead: { Player } }
): ()
	local winningteamname = "Parents"
	print(winningTeam == self.Babies, "Did babies win?")
	if winningTeam == self.Babies then
		winningteamname = "Babies"
	end

	for _, player in ipairs(self.Players) do
		player:RemoveTag("InGame")
	end
	self.OnStateUpdate:Fire("Ending", "Ending", workspace:GetServerTimeNow() + 5, winningteamname)

	-- add + win

	task.spawn(function()
		for _, player in ipairs(winningTeam.Alive) do
			local data = self.DataService:GetData(player)
			data.Wins += 1
			self.LevelService:AwardExperience(player, 50, true, " For winning")
			self.AwardService:GiveAward(player, "Cash", 100)
			self.DataService:SetData(player, data)
		end

		for _, player in ipairs(winningTeam.Dead) do
			local data = self.DataService:GetData(player)
			data.Wins += 1
			self.LevelService:AwardExperience(player, 50, true, " For winning")
			self.AwardService:GiveAward(player, "Cash", 100)
			self.DataService:SetData(player, data)
		end

		local losingTeam = winningTeam == self.Babies and self.Parents or self.Babies

		for _, player in ipairs(losingTeam.Alive) do
			self.LevelService:AwardExperience(player, 25, true, " For losing")
			self.AwardService:GiveAward(player, "Cash", 50)
		end

		for _, player in ipairs(losingTeam.Dead) do
			self.LevelService:AwardExperience(player, 25, true, " For losing")
			self.AwardService:GiveAward(player, "Cash", 50)
		end
	end)

	task.wait(5)
end

function DefaultSession.States.Cleanup(self: NexusInstanceDefaultSession): ()
	if self.BabyBuckPromise then
		self.BabyBuckPromise:cancel()
	end
	self.Map:Destroy()

	for _, player in ipairs(self.Players) do
		player:RemoveTag("InGame")
	end

	self.Parents = nil
	self.Babies = nil

	self.OnStateUpdate:Fire("Cleanup", "Cleanup", workspace:GetServerTimeNow() + 5)
end]]

function DefaultSession.Destroy(self: NexusInstanceDefaultSession): ()
	self.Parents = nil
	self.Babies = nil
	self.Map = nil
	self.GameSlot = nil
	self.Trove:Clean()
	GameSession.Destroy(self)
end

return NexusInstance.ToInstance(
		DefaultSession
	) :: NexusInstance.NexusInstanceClass<typeof(DefaultSession), (players: { Player }) -> NexusInstanceDefaultSession>
