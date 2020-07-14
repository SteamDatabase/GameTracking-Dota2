if CPortalSpawnerV2 == nil then
	CPortalSpawnerV2 = class({})
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:constructor( szSpawnerNameInput, szLocatorNameInput, nPortalHealthInput, flSummonTimeInput, flScaleInput, rgUnitsInfoInput, bInvulnerableInput )
	self.szSpawnerName = szSpawnerNameInput
	self.szLocatorName = szLocatorNameInput
	self.rgUnitsInfo = rgUnitsInfoInput
	self.nPortalHealth = nPortalHealthInput
	self.flSummonTime = flSummonTimeInput
	
	if bInvulnerableInput == nil then
		self.bInvulnerable = false
	else
		self.bInvulnerable = bInvulnerableInput
	end
	
	self.flScale = flScaleInput
	self.vFocusPosition = nil
	self.flFocusRadius = nil
	self.rgSpawners = {}
	self.rgSpawnedPortals = {}
	self.Encounter = nil
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetSpawnerType()
	return "CPortalSpawnerV2"
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:Precache( context )

	PrecacheUnitByNameSync( "npc_aghsfort_dark_portal_v2", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", context )
	PrecacheResource( "particle", "particles/portals/portal_ground_spawn_endpoint.vpcf", context )

	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		PrecacheUnitByNameSync( rgUnitInfo.EntityName, context, -1 )
	end
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:OnEncounterLoaded( EncounterInput )
	--print( "CPortalSpawnerV2:OnEncounterLoaded called for " .. self.szSpawnerName )

	self.Encounter = EncounterInput
	self.rgSpawners = self.Encounter:GetRoom():FindAllEntitiesInRoomByName( self.szLocatorName, false )
	
	if #self.rgSpawners == 0 then
		print( "Failed to find entity " .. self.szSpawnerName .. " as spawner position in map " .. self.Encounter:GetRoom():GetMapName() )
	end

	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CPortalSpawnerV2, 'OnEntityKilled' ), self )

end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetSpawnPositionCount()
	return #self.rgSpawners
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetSpawnPositions()
	return self.rgSpawners
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetSpawnCountPerSpawnPosition()

	local nCount = 0
	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		nCount = nCount + rgUnitInfo.Count
	end
	return nCount

end

----------------------------------------------------------------------------

function CPortalSpawnerV2:SetSpawnInfo( vMins, vMaxs, vEndPos )
	self.vMins = vMins
	self.vMaxs = vMaxs
	self.vEndPos = vEndPos
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:SetSpawnFocus( vCenter, flRadius )
	self.vFocusPosition = vCenter
	self.flFocusRadius = flRadius
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:SpawnSingleUnitType( rgUnitInfo, vLocation )

	local hSpawnedUnits = {}
	for i=1,rgUnitInfo.Count do

		local vSpawnPos = vLocation
		if rgUnitInfo.PositionNoise ~= nil then
			local nAttempts = 0
			while nAttempts < 16 do
				local vTestPos = vSpawnPos + RandomVector( RandomFloat( 0.0, rgUnitInfo.PositionNoise ) )
				vTestPos.z = GetGroundHeight( vTestPos, nil )
				if GridNav:CanFindPath( vTestPos, vLocation ) then
					vSpawnPos = vTestPos
					break
				end
				nAttempts = nAttempts + 1
			end
		end

		local hUnit = CreateUnitByName( rgUnitInfo.EntityName, vSpawnPos, true, nil, nil, rgUnitInfo.Team )

		if hUnit == nil then
			print( "ERROR! Failed to spawn unit named " .. rgUnitInfo.EntityName )
		else
			hUnit.bPortalUnit = true
			hUnit:FaceTowards( vLocation )
			if rgUnitInfo.PostSpawn ~= nil then
				rgUnitInfo.PostSpawn( hUnit )
			end
			table.insert( hSpawnedUnits, hUnit )
		end
	end

	return hSpawnedUnits
end

--------------------------------------------------------------------------------

function CPortalSpawnerV2:TrySpawningPortalUnits()

	local hSpawnedUnits={}
	local hActivatedPortals={}

	for i=#self.rgSpawnedPortals,1,-1 do
		local hPortal = self.rgSpawnedPortals[i]
		if hPortal ~= nil then
			if hPortal.bStartedSound == false and ( hPortal.flSpawnTime - GameRules:GetGameTime() ) <= 6 then
				hPortal.bStartedSound = true
				EmitSoundOn( "Aghsfort_DarkPortal.StartSummon", hPortal )
			end

			if hPortal.flSpawnTime <= GameRules:GetGameTime() then

				local nSpawned = 0
				local vLocation = hPortal:GetAbsOrigin()
				for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
					local hSingleSpawnedUnits = self:SpawnSingleUnitType( rgUnitInfo, vLocation )
					for _,hUnit in pairs ( hSingleSpawnedUnits ) do
						table.insert( hSpawnedUnits, hUnit )
					end
				end

				table.insert( hActivatedPortals, hPortal )
				--printf( "%s spawning %d units", self.szSpawnerName, nSpawned )
			end
		end
	end

	if #hSpawnedUnits > 0 then
		self.Encounter:OnSpawnerFinished( self, hSpawnedUnits )
	end

	-- Once a portal has been spawned, it can die
	for i=#hActivatedPortals,1,-1 do

		local hPortal = hActivatedPortals[i]
		StopSoundOn( "Aghsfort_DarkPortal.StartSummon", hPortal )	
		EmitSoundOn( "Aghsfort_DarkPortal.Complete", hPortal )

		self:RemoveSpawnedPortal( hPortal )
		self:DestroyPortal( hPortal )
		UTIL_Remove( hPortal )
	end

	return hSpawnedUnits

end

----------------------------------------------------------------------------

function CPortalSpawnerV2:SpawnPortal( hPortalEnt )

	hPortalEnt:SetTeam( DOTA_TEAM_BADGUYS )

	hPortalEnt:SetMaxHealth( self.nPortalHealth )
	hPortalEnt:SetBaseMaxHealth( self.nPortalHealth )
	hPortalEnt:Heal( self.nPortalHealth, nil )
	hPortalEnt:AddNewModifier( hPortalEnt, nil, "modifier_provide_vision", { duration = -1 } )
	hPortalEnt:AddNewModifier( hPortalEnt, nil, "modifier_magic_immune", { duration = -1 } )
	hPortalEnt:AddNewModifier( hPortalEnt, nil, "modifier_phased", { duration = -1 } )

	hPortalEnt:SetAbsScale( self.flScale )

	hPortalEnt.flSpawnTime = GameRules:GetGameTime() + self.flSummonTime
	hPortalEnt.bStartedSound = false

--	hPortalEnt.nAmbientFX = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, hPortalEnt )  
--	ParticleManager:SetParticleControlEnt( hPortalEnt.nAmbientFX , 1, hPortalEnt, PATTACH_POINT_FOLLOW, "attach_hitloc", hPortalEnt:GetAbsOrigin(), true )
--	ParticleManager:SetParticleControlEnt( hPortalEnt.nAmbientFX , 6, hPortalEnt, PATTACH_ABSORIGIN_FOLLOW, nil, hPortalEnt:GetAbsOrigin(), true )
--	ParticleManager:SetParticleControl( hPortalEnt.nAmbientFX , 10, Vector( 30, 30, 30 ) );

	if self.bInvulnerable == true then
		-- invulnerable portals make the portal invisible and place an effect on the ground
		hPortalEnt:AddEffects( EF_NODRAW )

		hPortalEnt.nWarningFX = ParticleManager:CreateParticle( "particles/portals/portal_ground_spawn_endpoint.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( hPortalEnt.nWarningFX, 0, hPortalEnt:GetAbsOrigin() )		

	else
		-- vulnerable portals need to remove the invulnerable modifier that's built in to the building
		hPortalEnt:RemoveModifierByName( "modifier_invulnerable" )

		hPortalEnt.nWarningFX = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, hPortalEnt )
		ParticleManager:SetParticleControlEnt( hPortalEnt.nWarningFX, 1, hPortalEnt, PATTACH_POINT_FOLLOW, "attach_hitloc", hPortalEnt:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( hPortalEnt.nWarningFX, 6, hPortalEnt, PATTACH_ABSORIGIN_FOLLOW, nil, hPortalEnt:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( hPortalEnt.nWarningFX, 10, Vector( self.flSummonTime*0.9, self.flSummonTime*0.9, self.flSummonTime*0.9 ) );
	end

	if self.flSummonTime <= 6 then
		hPortalEnt.bStartedSound = true
		EmitSoundOn( "Aghsfort_DarkPortal.StartSummon", hPortalEnt )
	end
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:DestroyPortal( hPortal )

	if hPortal.nWarningFX ~= nil then
		ParticleManager:DestroyParticle( hPortal.nWarningFX, false )
		hPortal.nWarningFX = nil
	end

--	if hVictim.nAmbientFX ~= nil then
--		ParticleManager:DestroyParticle( hPortal.nAmbientFX, false )
--		hPortal.nAmbientFX = nil
--	end

	StopSoundOn( "Aghsfort_DarkPortal.StartSummon", hPortal )	
   	EmitSoundOnLocationWithCaster( hPortal:GetAbsOrigin(), "Aghsfort_DarkPortal.Cancel", hPortal )

end

----------------------------------------------------------------------------

function CPortalSpawnerV2:ComputeSpawnerWeights( )

	if self.vFocusPosition == nil then
		return nil
	end

	-- Ok, focus position. Means we're going to preferentially pick
	-- spawn positions nearer to the spawn focus position
	local flTotalWeight = 0.0
	for i=1,#self.rgSpawners do
		local flDist = ( self.rgSpawners[i]:GetAbsOrigin() - self.vFocusPosition ):Length2D()
		local flWeight = math.exp( -0.5 * flDist * flDist / ( self.flFocusRadius * self.flFocusRadius ) )
		self.rgSpawners[i].flFocusWeight = flWeight
		flTotalWeight = flTotalWeight + flWeight
	end
	return flTotalWeight
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:RandomlySelectSpawner( Spawners, flTotalSpawnerWeight )

	if flTotalSpawnerWeight == nil then
		return math.random( 1, #Spawners )
	end

	-- Ok, focus position. Means we're going to preferentially pick
	-- spawn positions close to the focus position. 
	-- We've already computed weights in ComputeSpawnerWeights
	local flValue = RandomFloat( 0, flTotalSpawnerWeight )
	local flWeight = 0
	for i=1,#Spawners do
		flWeight = flWeight + Spawners[i].flFocusWeight
		if flValue < flWeight then
			return i
		end
	end
	return #Spawners
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:SpawnUnitsFromRandomSpawners( nSpawners )

	--print( "spawning from " .. nSpawners .. " " .. self.szSpawnerName .. " spawers out of " .. #self.rgSpawners )
	local hAllSpawnedUnits = {}
	local Spawners = nil
	local flTotalSpawnerWeight = self:ComputeSpawnerWeights( )
	for n=1,nSpawners do
		if Spawners == nil or #Spawners == 0 then
			Spawners = deepcopy( self.rgSpawners )
		end

		local nIndex = self:RandomlySelectSpawner( Spawners, flTotalSpawnerWeight )
		local Spawner = Spawners[ nIndex ]
		if Spawner == nil then
			print ( "ERROR!  CPortalSpawnerV2:SpawnUnitsFromRandomSpawners went WRONG!!!!!!!!!!!!!" )
		else

			if flTotalSpawnerWeight ~= nil then
				flTotalSpawnerWeight = flTotalSpawnerWeight - Spawner.flFocusWeight
			end		
				
			local vLocation = Spawner:GetAbsOrigin()

			local portalTable = 
			{ 	
				MapUnitName = "npc_aghsfort_dark_portal_v2", 
				origin = tostring( vLocation.x ) .. " " .. tostring( vLocation.y ) .. " " .. tostring( vLocation.z ),
				StatusHealth = self.nPortalHealth,
				teamnumber = DOTA_TEAM_BADGUYS,
				modelscale = self.flScale,
			}

			local hPortal = CreateUnitFromTable( portalTable, vLocation )
			self:SpawnPortal( hPortal )
			table.insert( hAllSpawnedUnits, hPortal )
			table.insert( self.rgSpawnedPortals, hPortal )
		end 
		table.remove( Spawners, nIndex )
	end

	return hAllSpawnedUnits
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:RemoveSpawnedPortal( hPortal )

	for i=#self.rgSpawnedPortals,1,-1 do
		if self.rgSpawnedPortals[i] == hPortal then
			table.remove( self.rgSpawnedPortals, i )
			return true
		end
	end
	return false

end

----------------------------------------------------------------------------

function CPortalSpawnerV2:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim == nil or hVictim:IsRealHero() then
		return
	end

	if self:RemoveSpawnedPortal( hVictim ) == true then
		if self.Encounter ~= nil then
			local hAttacker = nil
			if event.entindex_attacker ~= nil then
				hAttacker = EntIndexToHScript( event.entindex_attacker )
			end
			self.Encounter:OnPortalV2Killed( hVictim, hAttacker, self:GetSpawnCountPerSpawnPosition() )
		end

		self:DestroyPortal( hVictim )
	end
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetPortalUnitCount( event )
	return #self.rgSpawnedPortals
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetSpawnerName()
	return self.szSpawnerName
end

----------------------------------------------------------------------------

function CPortalSpawnerV2:GetLocatorName()
	return self.szLocatorName
end