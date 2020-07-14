if CDotaSpawner == nil then
	CDotaSpawner = class({})
end

----------------------------------------------------------------------------

function CDotaSpawner:constructor( szSpawnerNameInput, szLocatorNameInput, rgUnitsInfoInput )
	self.szSpawnerName = szSpawnerNameInput
	self.szLocatorName = szLocatorNameInput
	self.rgUnitsInfo = rgUnitsInfoInput
	self.rgSpawners = {}
	self.Encounter = nil
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnerType()
	return "CDotaSpawner"
end

----------------------------------------------------------------------------

function CDotaSpawner:Precache( context )
	--print( "CDotaSpawner:Precache called for " .. self.szSpawnerName )

	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		PrecacheUnitByNameSync( rgUnitInfo.EntityName, context, -1 )
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:OnEncounterLoaded( EncounterInput )
	--print( "CDotaSpawner:OnEncounterLoaded called for " .. self.szSpawnerName )
	self.Encounter = EncounterInput
	self.rgSpawners = self.Encounter:GetRoom():FindAllEntitiesInRoomByName( self.szLocatorName, false )
	if #self.rgSpawners == 0 then
		print( "Failed to find entity " .. self.szSpawnerName .. " as spawner position in map " .. self.Encounter:GetRoom():GetMapName() )
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnPositionCount()
	return #self.rgSpawners
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnCountPerSpawnPosition()

	local nCount = 0
	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		nCount = nCount + rgUnitInfo.Count
	end
	return nCount

end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnUnits()
	
	if #self.rgSpawners == 0 then
		print( "ERROR - Spawner " .. self.szSpawnerName .. " found no spawn entities, cannot spawn" )
		return
	end

	local nSpawned = 0

	local hSpawnedUnits = {}

	for nSpawnerIndex,hSpawner in pairs( self.rgSpawners ) do
		local vLocation = hSpawner:GetAbsOrigin()
		for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
			local hSingleSpawnedUnits = self:SpawnSingleUnitType( rgUnitInfo, vLocation )
			nSpawned = nSpawned + rgUnitInfo.Count

			for _,hUnit in pairs ( hSingleSpawnedUnits ) do
				table.insert( hSpawnedUnits, hUnit )
			end
		end
	end

	printf( "%s spawning %d units", self.szSpawnerName, nSpawned )

	if #hSpawnedUnits > 0 then
		self.Encounter:OnSpawnerFinished( self, hSpawnedUnits )
	end

	return hSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnSingleUnitType( rgUnitInfo, vLocation )
	local hSpawnedUnits = {}
	for i=1,rgUnitInfo.Count do
		local vSpawnPos = vLocation
		if rgUnitInfo.PositionNoise ~= nil then
			vSpawnPos = vSpawnPos + RandomVector( RandomFloat( 0.0, rgUnitInfo.PositionNoise ) )
		end

		local hUnit = CreateUnitByName( rgUnitInfo.EntityName, vSpawnPos, true, nil, nil, rgUnitInfo.Team )

		if hUnit == nil then
			print( "ERROR! Failed to spawn unit named " .. rgUnitInfo.EntityName )

		else
			hUnit:FaceTowards( vLocation )
			if rgUnitInfo.PostSpawn ~= nil then
				rgUnitInfo.PostSpawn( hUnit )
			end
			table.insert( hSpawnedUnits, hUnit )
		end
	end

	return hSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawners()
	return self.rgSpawners
end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnUnitsFromRandomSpawners( nSpawners )
	print( "spawning from " .. nSpawners .. " " .. self.szSpawnerName .. " spawers out of " .. #self.rgSpawners )
	local hAllSpawnedUnits = {}
	local Spawners = nil
	for n=1,nSpawners do
		if Spawners == nil or #Spawners == 0 then
			Spawners = deepcopy( self.rgSpawners )
		end

		--print ( #Spawners .. " potential spawners to use." )

		local nIndex = math.random( 1, #Spawners )
		local Spawner = Spawners[ nIndex ]
		if Spawner == nil then
			print ( "ERROR!  SpawnUnitsFromRandomSpawners went WRONG!!!!!!!!!!!!!" )
		else
			local vLocation = Spawner:GetAbsOrigin()
			for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
				local hSpawnedUnits = self:SpawnSingleUnitType( rgUnitInfo, vLocation )
				for _,hUnit in pairs ( hSpawnedUnits ) do
					table.insert( hAllSpawnedUnits, hUnit )
				end
			end
		end 
		table.remove( Spawners, nIndex )
	end

	if #hAllSpawnedUnits > 0 then
		self.Encounter:OnSpawnerFinished( self, hAllSpawnedUnits )
	end

	return hAllSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnerName()
	return self.szSpawnerName
end

----------------------------------------------------------------------------

function CDotaSpawner:GetLocatorName()
	return self.szLocatorName
end