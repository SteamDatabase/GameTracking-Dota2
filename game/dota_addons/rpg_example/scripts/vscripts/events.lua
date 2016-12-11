--[[ Events ]]

--------------------------------------------------------------------------------
-- GameEvent:OnGameRulesStateChange
--------------------------------------------------------------------------------
function CRPGExample:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		print( "OnGameRulesStateChange: Custom Game Setup" )
		GameRules:SetTimeOfDay( 0.25 )
		SendToServerConsole( "dota_daynightcycle_pause 1" )
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
			PlayerResource:SetCustomTeamAssignment( nPlayerID, 2 ) -- put each player on Radiant team

			self:OnLoadAccountRecord( nPlayerID )
		end

	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print( "OnGameRulesStateChange: Hero Selection" )
		self:InitializeBuildingOwnership()
		self:SpawnCreatures()
		self:SpawnItems()

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		print( "OnGameRulesStateChange: Pre Game" )

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "OnGameRulesStateChange: Game In Progress" )

	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCSpawned
--------------------------------------------------------------------------------
function CRPGExample:OnNPCSpawned( event )
	hSpawnedUnit = EntIndexToHScript( event.entindex )

	if hSpawnedUnit:IsOwnedByAnyPlayer() and hSpawnedUnit:IsRealHero() then
		local hPlayerHero = hSpawnedUnit
		self._GameMode:SetContextThink( "self:Think_InitializePlayerHero( hPlayerHero )", function() return self:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnEntityKilled
--------------------------------------------------------------------------------
function CRPGExample:OnEntityKilled( event )
	hDeadUnit = EntIndexToHScript( event.entindex_killed )
	hAttackerUnit = EntIndexToHScript( event.entindex_attacker )

	if hDeadUnit:IsCreature() then
		self:PlayDeathSound( hDeadUnit )
		self:GrantItemDrop( hDeadUnit )

		if hAttackerUnit.PlayKillEffect ~= nil then
			hAttackerUnit:PlayKillEffect( hDeadUnit )
		end
	end
end

--------------------------------------------------------------------------------
-- GrantItemDrop
--------------------------------------------------------------------------------
function CRPGExample:GrantItemDrop( hDeadUnit )
	if hDeadUnit.itemTable == nil then
		return
	end

	local flMaxHeight = RandomFloat( 300, 450 )

	if RandomFloat( 0, 1 ) > 0.6 then
		local sItemName = GetRandomElement( hDeadUnit.itemTable )
		self:LaunchWorldItemFromUnit( sItemName, flMaxHeight, 0.5, hDeadUnit )
	end
end

--------------------------------------------------------------------------------
-- PlayDeathSound
--------------------------------------------------------------------------------
function CRPGExample:PlayDeathSound( hDeadUnit )
	if hDeadUnit:GetUnitName() == "npc_dota_creature_zombie" or hDeadUnit:GetUnitName() == "npc_dota_creature_zombie_crawler" then
		EmitSoundOn( "Zombie.Death", hDeadUnit )

	elseif hDeadUnit:GetUnitName() == "npc_dota_creature_bear" then
		EmitSoundOn( "Bear.Death", hDeadUnit )

	elseif hDeadUnit:GetUnitName() == "npc_dota_creature_bear_large" then
		EmitSoundOn( "BearLarge.Death", hDeadUnit )

	end
end

--------------------------------------------------------------------------------
-- Think_InitializePlayerHero
--------------------------------------------------------------------------------
function CRPGExample:Think_InitializePlayerHero( hPlayerHero )
	if not hPlayerHero then
		return 0.1
	end

	local nPlayerID = hPlayerHero:GetPlayerID()

	if self._tPlayerHeroInitStatus[ nPlayerID ] == false then
		hPlayerHero.PlayKillEffect = Juggernaut_PlayKillEffect
		PlayerResource:SetCameraTarget( nPlayerID, hPlayerHero )
		PlayerResource:SetOverrideSelectionEntity( nPlayerID, hPlayerHero )
		PlayerResource:SetGold( nPlayerID, 0, true )
		PlayerResource:SetGold( nPlayerID, 0, false )
		hPlayerHero:HeroLevelUp( false )
		hPlayerHero:UpgradeAbility( hPlayerHero:GetAbilityByIndex( 0 ) )
		hPlayerHero:UpgradeAbility( hPlayerHero:GetAbilityByIndex( 1 ) )
		hPlayerHero:SetIdleAcquire( false )

		if self._tPlayerDeservesTPAtSpawn[ nPlayerID ] then
			print( "Player deserves a TP at spawn: " .. nPlayerID )
			local hTP = CreateItem( "item_teleport", hPlayerHero, hPlayerHero )
			hTP:SetPurchaseTime( 0 )
			hPlayerHero:AddItem( hTP )
		end

		if GetMapName() == "rpg_example" then
			local nLightParticleID = ParticleManager:CreateParticle( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN, hPlayerHero )
			ParticleManager:SetParticleControlEnt( nLightParticleID, PATTACH_ABSORIGIN, hPlayerHero, PATTACH_ABSORIGIN, "attach_origin", hPlayerHero:GetAbsOrigin(), true )
		end

		self._tPlayerHeroInitStatus[ nPlayerID ] = true
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnPlayerGainedLevel
--------------------------------------------------------------------------------
function CRPGExample:OnPlayerGainedLevel( event )
	local hPlayer = EntIndexToHScript( event.player )
	local hPlayerHero = hPlayer:GetAssignedHero()

	hPlayerHero:SetHealth( hPlayerHero:GetMaxHealth() )
	hPlayerHero:SetMana( hPlayerHero:GetMaxMana() )
end

function CRPGExample:OnItemPickedUp( event )
	local hPlayerHero = EntIndexToHScript( event.HeroEntityIndex )
	EmitGlobalSound( "ui.inv_equip_highvalue" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnSaveAccountRecord
--------------------------------------------------------------------------------
function CRPGExample:OnSaveAccountRecord( nPlayerID )

	print( "OnSaveAccountRecord: " .. nPlayerID );

	return self._tPlayerIDToAccountRecord[nPlayerID]
end

function CRPGExample:RecordActivatedCheckpoint( nPlayerID, strCheckpoint )
	tblAccountRecord = {}
	if self._tPlayerIDToAccountRecord[nPlayerID] then
		tblAccountRecord = self._tPlayerIDToAccountRecord[nPlayerID]
	else
		self._tPlayerIDToAccountRecord[nPlayerID] = tblAccountRecord
	end

	if not tblAccountRecord["checkpoints"] then
		tblAccountRecord["checkpoints"] = strCheckpoint
	else
		tblAccountRecord["checkpoints"] = tblAccountRecord["checkpoints"] .. "," .. strCheckpoint
	end
end

function CRPGExample:OnLoadAccountRecord( nPlayerID )
	local tblAccountRecord = GameRules:GetPlayerCustomGameAccountRecord( nPlayerID )
	if not tblAccountRecord then
		return
	end

	print( "OnLoadAccountRecord: " .. nPlayerID );

	-- Store off their account record, if found, we may be changing/saving it later
	if tblAccountRecord then
		PrintTable( tblAccountRecord, " " )
		self._tPlayerIDToAccountRecord[nPlayerID] = tblAccountRecord
	end
end

function CRPGExample:InitializeBuildingOwnership()
	local hStartBuilding = Entities:FindByName( nil, "checkpoint00_building" )
	hStartBuilding:SetTeam( nGOOD_TEAM )

	for nPlayerID, tblAccountRecord in pairs( self._tPlayerIDToAccountRecord ) do
		if tblAccountRecord["checkpoints"] then
			local tblCheckpoints = string.split( tblAccountRecord["checkpoints"], "," )
			for k, strCheckpoint in pairs( tblCheckpoints ) do
				local hBuilding = Entities:FindByName( nil, strCheckpoint .. "_building" )
				if hBuilding then
					hBuilding:SetTeam( nGOOD_TEAM )

					print( "Player has non-start checkpoint: " .. nPlayerID )
					self._tPlayerDeservesTPAtSpawn[ nPlayerID ] = true
				end
			end
		end
	end
end


function PlayPACrit( hAttacker, hVictim )
	local bloodEffect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	if hVictim:IsMechanical() then
		bloodEffect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	end
	local nFXIndex = ParticleManager:CreateParticle( bloodEffect, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hVictim, PATTACH_POINT_FOLLOW, "attach_hitloc", hVictim:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, hVictim:GetAbsOrigin() )
	local flHPRatio = math.min( 1.0, hVictim:GetMaxHealth() / 200 )
	ParticleManager:SetParticleControlForward( nFXIndex, 1, RandomFloat( 0.5, 1.0 ) * flHPRatio * ( hAttacker:GetAbsOrigin() - hVictim:GetAbsOrigin() ):Normalized() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 10, hVictim, PATTACH_ABSORIGIN_FOLLOW, "", hVictim:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function PlayLifeStealerEmerge( hAttacker, hVictim )
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, hVictim ) )
end

function Juggernaut_PlayKillEffect( self, hVictim )
	if hVictim:GetMaxHealth() > 150 and RandomFloat( 0, 1 ) > 0.75 then
		PlayLifeStealerEmerge( self, hVictim )
	else
		PlayPACrit( self, hVictim )
	end
end