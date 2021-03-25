require( "hero_ability_utils" )

if CDotaSpawner == nil then
	CDotaSpawner = class({})
end

----------------------------------------------------------------------------

function CDotaSpawner:constructor( szSpawnerNameInput, rgUnitsInfoInput, hScenario, bSpawnOnPrecacheComplete )
	self.szSpawnerName = szSpawnerNameInput
	self.rgUnitsInfo = rgUnitsInfoInput
	self.bPrecached = false
	self.nAsyncPrecacheCount = 0
	self.rgSpawnedUnits = {}
	self.hScenario = hScenario
	self.bSpawnOnPrecacheComplete = bSpawnOnPrecacheComplete

	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaSpawner, 'OnEntityKilled' ), self )

	self:PrecacheUnits()
	if self.hScenario then
		self.hScenario:AddSpawner()
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnUnits()
	if ( self:IsFullyPrecached() ) then
	--	print( self.szSpawnerName .. " spawning units" )
	else
		print( self.szSpawnerName .. " spawning units that have not yet been fully precached." )
	end

	local rgSpawners = Entities:FindAllByName( self.szSpawnerName )
	if #rgSpawners == 0 then
		print( "Failed to find entity " .. self.szSpawnerName .. " as spawner position" )
		return
	end

	for _,hSpawner in pairs( rgSpawners ) do
		local vLocation = hSpawner:GetAbsOrigin()

		for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
			self:SpawnSingleUnitType( rgUnitInfo, vLocation )
		end
	end

	local event = {}
	event[ "spawner_name" ] = self:GetSpawnerName()
	FireGameEvent( "spawner_finished", event )
end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnSingleUnitType( rgUnitInfo, vLocation )
	for i=1,rgUnitInfo.Count do
		local vSpawnPos = vLocation
		if rgUnitInfo.PositionNoise ~= nil then
			vSpawnPos = vSpawnPos + RandomVector( RandomFloat( 0.0, rgUnitInfo.PositionNoise ) )
		end

		local hUnit = nil
		if rgUnitInfo.BotPlayer ~= nil then
			hUnit = GameRules:AddBotPlayerWithEntityScript( rgUnitInfo.EntityName, rgUnitInfo.BotPlayer.BotName, rgUnitInfo.Team, rgUnitInfo.BotPlayer.EntityScript, true )
			if hUnit ~= nil then
				FindClearSpaceForUnit( hUnit, vSpawnPos, true )
				
				if rgUnitInfo.BotPlayer.StartingHeroLevel ~= nil then
					while hUnit:GetLevel() < rgUnitInfo.BotPlayer.StartingHeroLevel do
						hUnit:HeroLevelUp( false )
					end

					if rgUnitInfo.BotPlayer.AbilityBuild ~= nil then
						LearnHeroAbilities( hUnit, rgUnitInfo.BotPlayer.AbilityBuild )
					end
				end

				if rgUnitInfo.BotPlayer.StartingItems then
					for _,szItemName in pairs ( rgUnitInfo.BotPlayer.StartingItems ) do
						hUnit:AddItemByName( szItemName )
					end
				end

			end
		else
			hUnit = CreateUnitByName( rgUnitInfo.EntityName, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
		end
		

		if hUnit == nil then
			print( "CDotaNPXScenario:SetupEntities - ERROR! Failed to spawn unit named " .. rgUnitInfo.EntityName )

		else
			hUnit:FaceTowards( vLocation )
			if rgUnitInfo.PostSpawn ~= nil then
				rgUnitInfo.PostSpawn( hUnit )
			end

			if rgUnitInfo.StartingHealth ~= nil then
				hUnit:SetHealth( rgUnitInfo.StartingHealth )
				print( "setting health on " .. hUnit:GetUnitName() .. " to " .. rgUnitInfo.StartingHealth )
			end

			if rgUnitInfo.StartingMana ~= nil then
				hUnit:SetMana( rgUnitInfo.StartingMana )
			end
			table.insert( self.rgSpawnedUnits, hUnit )
		end
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:PrecacheUnits()
	--print( "CDotaSpawner:PrecacheUnits called for " .. self.szSpawnerName )
	if self.bPrecached then
		return
	end

	self.bPrecached = true

	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		PrecacheUnitByNameAsync( rgUnitInfo.EntityName, function ( sg ) self:OnPrecacheComplete( sg ) end, -1 )
		self.nAsyncPrecacheCount = self.nAsyncPrecacheCount + 1
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnedUnits()
	return self.rgSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:RemoveSpawnedUnits()
	for i=#self.rgSpawnedUnits,1,-1 do
		local hUnit = self.rgSpawnedUnits[ i ]
		if hUnit and not hUnit:IsNull() then
			UTIL_Remove( hUnit )
		end
	end
	self.rgSpawnedUnits = {}
end

----------------------------------------------------------------------------

function CDotaSpawner:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim == nil or hVictim:IsRealHero() then
		return
	end

	for i=#self.rgSpawnedUnits,1,-1 do
		if self.rgSpawnedUnits[i] == hVictim then
			table.remove( self.rgSpawnedUnits, i )
		end
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:OnPrecacheComplete( sg )
	-- print( "CDotaSpawner:OnPrecacheComplete( " .. sg .. " )" )
	self.nAsyncPrecacheCount = self.nAsyncPrecacheCount - 1
	if self:IsFullyPrecached() and self.bSpawnOnPrecacheComplete then
		self:SpawnUnits()
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:IsFullyPrecached()
	return self.bPrecached and self.nAsyncPrecacheCount == 0
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnerName()
	return self.szSpawnerName
end
