if CPortalSpawner == nil then
	CPortalSpawner = class({})
end

----------------------------------------------------------------------------

function CPortalSpawner:constructor( szSpawnerNameInput, szLocatorNameInput, nPortalHealthInput, flInitialPortalSpawnDelayInput, flInitialSummonTimeInput, flPortalIntervalInput, flScaleInput, rgUnitsInfoInput )
	self.szSpawnerName = szSpawnerNameInput
	self.szLocatorName = szLocatorNameInput
	self.rgUnitsInfo = rgUnitsInfoInput
	self.nPortalHealth = nPortalHealthInput
	self.flInitialPortalSpawnDelay = flInitialPortalSpawnDelayInput
	self.flInitialSummonTime = flInitialSummonTimeInput
	self.flPortalInterval = flPortalIntervalInput
	self.flScale = flScaleInput

	self.nNumSpawnsRemaining = 3

	self.Encounter = nil

	self.vLocation = nil
	self.bHasCreatedPortal = false
	self.hPortalEnt = nil
	self.flNextSpawnTime = -1.0
	self.nWarningFX = nil
end

----------------------------------------------------------------------------

function CPortalSpawner:GetSpawnerType()
	return "CPortalSpawner"
end

----------------------------------------------------------------------------

function CPortalSpawner:Precache( context )
	--print( "CPortalSpawner:Precache called for " .. self.szSpawnerName )

	PrecacheUnitByNameSync( "npc_aghsfort_dark_portal", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )

	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		PrecacheUnitByNameSync( rgUnitInfo.EntityName, context, -1 )
	end
end

----------------------------------------------------------------------------

function CPortalSpawner:SetLocation( vLocationInput )
	self.vLocation = vLocationInput
end

----------------------------------------------------------------------------

function CPortalSpawner:OnEncounterLoaded( EncounterInput )
	--print( "CPortalSpawner:OnEncounterLoaded called for " .. self.szSpawnerName )
	self.Encounter = EncounterInput

	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CPortalSpawner, 'OnEntityKilled' ), self )
end

----------------------------------------------------------------------------

function CPortalSpawner:Start( flStartTime )
	self.flNextSpawnTime = GameRules:GetGameTime() + self.flInitialPortalSpawnDelay
end

----------------------------------------------------------------------------

function CPortalSpawner:IsDestroyed()
	if self.bHasCreatedPortal == false then
		return false
	end

	if not self.hPortalEnt or self.hPortalEnt:IsNull() or self.hPortalEnt:IsAlive() == false then
		return true
	end

	return false
end

----------------------------------------------------------------------------
--[[
function CPortalSpawner:GetSpawnCountPerSpawnPosition()

	local nCount = 0
	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		nCount = nCount + rgUnitInfo.Count
	end
	return nCount

end
--]]

----------------------------------------------------------------------------

function CPortalSpawner:SpawnSingleUnitType( rgUnitInfo )

	local hSpawnedUnits = {}
	for i=1,rgUnitInfo.Count do

		local vSpawnPos = self.vLocation
		if rgUnitInfo.PositionNoise ~= nil then
			local nAttempts = 0
			while nAttempts < 16 do
				local vTestPos = vSpawnPos + RandomVector( RandomFloat( 0.0, rgUnitInfo.PositionNoise ) )
				vTestPos.z = GetGroundHeight( vTestPos, nil )
				if GridNav:CanFindPath( vTestPos, self.vLocation ) then
					vSpawnPos = vTestPos
					break
				end
				nAttempts = nAttempts + 1
			end
		end

		local hUnit = CreateUnitByName( rgUnitInfo.EntityName, vSpawnPos, true, nil, nil, rgUnitInfo.Team )

		if hUnit == nil then
			print( "ERROR! Failed to spawn unit named " .. rgUnitInfo.EntityName )
			return nil
		else
			hUnit.bPortalUnit = true
			hUnit:FaceTowards( self.vLocation )
			if rgUnitInfo.PostSpawn ~= nil then
				rgUnitInfo.PostSpawn( hUnit )
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hUnit );
			ParticleManager:SetParticleControl( nFXIndex, 0, hUnit:GetAbsOrigin() );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 3, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 4, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			table.insert( hSpawnedUnits, hUnit )
		end
	end

	return hSpawnedUnits
end

----------------------------------------------------------------------------

function CPortalSpawner:TrySpawningUnits()
	--print( "CPortalSpawner:TrySpawningUnits" )

	-- Don't spawn if Start() hasn't been called
	if self.flNextSpawnTime < 0 then
		return
	end

	if self.bHasCreatedPortal == false then
		local flTimeReaminingToPortalSpawn = self.flNextSpawnTime - GameRules:GetGameTime()

		if flTimeReaminingToPortalSpawn <= 0 then
			--print( "Portal named " .. self:GetSpawnerName() .. " spawning portal!" )
			self:SpawnPortal()
		end
	end

	if self.bHasCreatedPortal == false then
		return
	end

	if self.hPortalEnt ~= nil and self.hPortalEnt:IsNull() == false and self.hPortalEnt:IsAlive() then
		local flTimeRemaining = self.flNextSpawnTime - GameRules:GetGameTime()
		--print( "Portal named " .. self:GetSpawnerName() .. " has " .. flTimeRemaining .. " time remaining till spawn." )

		if flTimeRemaining <= 0 then
			--print( "Portal named " .. self:GetSpawnerName() .. " is spawning units!" )
			self:SpawnUnits()
			if self.nNumSpawnsRemaining > 0 then
				self.flNextSpawnTime = self.flNextSpawnTime + self.flPortalInterval
			else
				self.flNextSpawnTime = -1	-- disabled from here on out
			end
		end

		if flTimeRemaining <= 5 and flTimeRemaining > 0 and self.nWarningFX == nil then
			--print( "Portal named " .. self:GetSpawnerName() .. " creating warning fx and sounds" )

			self.nWarningFX = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hPortalEnt )  
			ParticleManager:SetParticleControlEnt( self.nWarningFX, 1, self.hPortalEnt, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hPortalEnt:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nWarningFX, 6, self.hPortalEnt, PATTACH_ABSORIGIN_FOLLOW, nil, self.hPortalEnt:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nWarningFX, 10, Vector( flTimeRemaining*0.9, flTimeRemaining*0.9, flTimeRemaining*0.9 ) );

			EmitSoundOn( "Aghsfort_DarkPortal.StartSummon", self.hPortalEnt )
		end
	end
end

----------------------------------------------------------------------------

function CPortalSpawner:SpawnUnits()
	if self.vLocation == nil then
		print( "ERROR - Spawner " .. self.szSpawnerName .. " does not have a valid location!" )
		return
	end

	local nSpawned = 0

	local hSpawnedUnits = {}

	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		local hSingleSpawnedUnits = self:SpawnSingleUnitType( rgUnitInfo )
		nSpawned = nSpawned + rgUnitInfo.Count

		for _,hUnit in pairs ( hSingleSpawnedUnits ) do
			table.insert( hSpawnedUnits, hUnit )
		end
	end

	--printf( "%s spawning %d units", self.szSpawnerName, nSpawned )

	if self.nWarningFX ~= nil then
		ParticleManager:DestroyParticle( self.nWarningFX, false )
		self.nWarningFX = nil
	end	

	EmitSoundOn( "Aghsfort_DarkPortal.Complete", self.hPortalEnt )
	StopSoundOn( "Aghsfort_DarkPortal.StartSummon", self.hPortalEnt )

	if #hSpawnedUnits > 0 then
		self.Encounter:OnSpawnerFinished( self, hSpawnedUnits )
	end

	self.nNumSpawnsRemaining = self.nNumSpawnsRemaining - 1

	if self.nNumSpawnsRemaining <= 0 then
		self.hPortalEnt:SetSkin( 1 )
	end

--[[
	if self.nNumSpawnsRemaining <= 0 then
		if self.Encounter ~= nil then
			local hAttacker = nil
			self.Encounter:OnPortalKilled( self.hPortalEnt, hAttacker, 0 )
		end

		self:DestroyPortal( true )
	end
--]]
	return hSpawnedUnits
end

----------------------------------------------------------------------------

function CPortalSpawner:SpawnPortal()
	--print( "CPortalSpawner:SpawnPortal" )

	if self.bHasCreatedPortal == true then
		print( 'ERROR: Trying to spawn a portal named ' .. self.szSpawnerName .. ' but it has already spawned a portal!')
		return
	end

	if self.hPortalEnt ~= nil then
		print( 'ERROR: Trying to spawn a portal named ' .. self.szSpawnerName .. ' but it already has a portal!')
		return
	end

	if self.vLocation == nil then
		print( 'ERROR: Trying to spawn a portal named ' .. self.szSpawnerName .. ' with a nil location!' )
		return
	end

	local portalTable = 
	{ 	
		MapUnitName = "npc_aghsfort_dark_portal", 
		origin = tostring( self.vLocation.x ) .. " " .. tostring( self.vLocation.y ) .. " " .. tostring( self.vLocation.z ),
		StatusHealth = self.nPortalHealth,
		teamnumber = DOTA_TEAM_BADGUYS,
		modelscale = self.flScale,
	}

	self.hPortalEnt = CreateUnitFromTable( portalTable, self.vLocation )

	self.hPortalEnt:SetTeam( DOTA_TEAM_BADGUYS )
	self.hPortalEnt:RemoveModifierByName( "modifier_invulnerable" )

	self.hPortalEnt:SetMaxHealth( self.nPortalHealth )
	self.hPortalEnt:SetBaseMaxHealth( self.nPortalHealth )
	self.hPortalEnt:Heal( self.nPortalHealth, nil )
	self.hPortalEnt:AddNewModifier( self.hPortalEnt, nil, "modifier_provide_vision", { duration = -1 } )
	self.hPortalEnt:AddNewModifier( self.hPortalEnt, nil, "modifier_magic_immune", { duration = -1 } )
	self.hPortalEnt:AddNewModifier( self.hPortalEnt, nil, "modifier_phased", { duration = -1 } )

	self.hPortalEnt:SetAbsScale( self.flScale )

	self.flNextSpawnTime = GameRules:GetGameTime() + self.flInitialSummonTime

--	hPortalEnt.nAmbientFX = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, hPortalEnt )  
--	ParticleManager:SetParticleControlEnt( hPortalEnt.nAmbientFX , 1, hPortalEnt, PATTACH_POINT_FOLLOW, "attach_hitloc", hPortalEnt:GetAbsOrigin(), true )
--	ParticleManager:SetParticleControlEnt( hPortalEnt.nAmbientFX , 6, hPortalEnt, PATTACH_ABSORIGIN_FOLLOW, nil, hPortalEnt:GetAbsOrigin(), true )
--	ParticleManager:SetParticleControl( hPortalEnt.nAmbientFX , 10, Vector( 30, 30, 30 ) );

--	self.nWarningFX = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hPortalEnt )
--	ParticleManager:SetParticleControlEnt( self.nWarningFX, 1, self.hPortalEnt, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hPortalEnt:GetAbsOrigin(), true )
--	ParticleManager:SetParticleControlEnt( self.nWarningFX, 6, self.hPortalEnt, PATTACH_ABSORIGIN_FOLLOW, nil, self.hPortalEnt:GetAbsOrigin(), true )
--	ParticleManager:SetParticleControl( self.nWarningFX, 10, Vector( self.flNextSpawnTime*0.9, self.flNextSpawnTime*0.9, self.flNextSpawnTime*0.9 ) );

	EmitSoundOn( "Aghsfort_DarkPortal.Created", self.hPortalEnt )

	self.bHasCreatedPortal = true
end

----------------------------------------------------------------------------

function CPortalSpawner:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim == nil or hVictim:IsRealHero() then
		return
	end

	if hVictim ~= self.hPortalEnt then
		return
	end

	if self.Encounter ~= nil then
		local hAttacker = nil
		if event.entindex_attacker ~= nil then
			hAttacker = EntIndexToHScript( event.entindex_attacker )
		end

		local nSupressedUnits = 0
		for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
			nSupressedUnits = nSupressedUnits + ( rgUnitInfo.Count * self.nNumSpawnsRemaining )
		end

		self.Encounter:OnPortalKilled( hVictim, hAttacker, nSupressedUnits )
	end

	self:DestroyPortal( false )
end


----------------------------------------------------------------------------

function CPortalSpawner:DestroyPortal( bRemove )
	StopSoundOn( "Aghsfort_DarkPortal.StartSummon", self.hPortalEnt )
	StopSoundOn( "Aghsfort_DarkPortal.Created", self.hPortal )	
	if self.hPortal and not self.hPortal:IsNull() then
		EmitSoundOnLocationWithCaster( self.hPortal:GetAbsOrigin(), "Aghsfort_DarkPortal.Cancel", self.hPortal )
	end

	if self.nWarningFX ~= nil then
		ParticleManager:DestroyParticle( self.nWarningFX, false )
		self.nWarningFX = nil
	end

	if bRemove and self.hPortalEnt and not self.hPortalEnt:IsNull() then
		UTIL_Remove( self.hPortalEnt )
		self.hPortalEnt = nil
	end

--	if hVictim.nAmbientFX ~= nil then
--		ParticleManager:DestroyParticle( hPortal.nAmbientFX, false )
--		hPortal.nAmbientFX = nil
--	end
end

----------------------------------------------------------------------------

function CPortalSpawner:GetSpawnerName()
	return self.szSpawnerName
end

----------------------------------------------------------------------------

function CPortalSpawner:GetLocatorName()
	return self.szLocatorName
end

----------------------------------------------------------------------------

function CPortalSpawner:GetNumSpawnsRemaining()
	return self.nNumSpawnsRemaining
end
