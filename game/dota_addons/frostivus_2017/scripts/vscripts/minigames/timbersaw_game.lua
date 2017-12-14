require('minigames/minigame_base')

TimbersawGame = MiniGame:new()

function TimbersawGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("whirling_death_lua", function(...) end)
		PrecacheItemByNameAsync("timber_chain_lua", function(...) end)
		PrecacheItemByNameAsync("chakram_lua", function(...) end)
		PrecacheItemByNameAsync("chakram_return_lua", function(...) end)
	end
end

function TimbersawGame:GameStart()
	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()

	local spawner = Entities:FindByName(nil, "snow_large_center")
	self:SpawnVisionDummies(spawner)

	self.bot_left = Entities:FindByName(nil, "snow_large_bottom_left"):GetAbsOrigin()
	self.top_right = Entities:FindByName(nil, "snow_large_top_right"):GetAbsOrigin()
	self.center = Entities:FindByName(nil, "snow_large_center"):GetAbsOrigin()

	self:CreateForest()
end

function TimbersawGame:GameEnd()
	self:DestroyVisionDummies()
	self:HighScoreGameEndGame()
end

function TimbersawGame:OnTreesDestroyed(caster, numTrees)
	if not self.isRunning then return end
	self:AddHighScoreForPlayer(caster:GetTeam(), numTrees)
end

function TimbersawGame:CreateForest()
	local centerRadius = 700
	local treeCount = 1500
	-- GameMode:DestroyForest()
	for i=0,treeCount do
		local randomX = RandomInt(self.bot_left.x, self.top_right.x)
		local randomY = RandomInt(self.bot_left.y, self.top_right.y)
		local randomPosition = Vector(randomX, randomY, 0)
		if (randomPosition - self.center):Length2D() > centerRadius then
			CreateTempTree(randomPosition, self.duration)
		end
	end
end