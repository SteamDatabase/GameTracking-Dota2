require('minigames/minigame_base')

SnowballGame = MiniGame:new()

function SnowballGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("snowball_lua", function(...) end)
		-- PrecacheUnitByNameAsync("unit_name", function(...) end)
	end
end

function SnowballGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_medium_center")
	self:SpawnVisionDummies(spawner)

	for i=1,10 do
		CreateTempTree( spawner:GetAbsOrigin() + RandomVector(800), 90 )
	end
end

function SnowballGame:GameEnd()
	self:DestroyVisionDummies()
	self:CleanUp()
end