require('minigames/minigame_base')

EnchantressGame = MiniGame:new()

function EnchantressGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("item_blink_lua", function(...) end)
		PrecacheItemByNameAsync("impetus_lua", function(...) end)
	end
end

function EnchantressGame:GameStart()
	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()

	local spawner = Entities:FindByName(nil, "snow_medium_center")
	self:SpawnVisionDummies(spawner)
end

function EnchantressGame:GameEnd()
	self:DestroyVisionDummies()
	self:HighScoreGameEndGame()
end

function EnchantressGame:OnImpetusHit(attacker, distance)
	if not self.isRunning then return end
	
	self:SubmitMaxHighScore(attacker:GetTeam(), distance)
end