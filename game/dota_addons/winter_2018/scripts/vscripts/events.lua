
function CHoldout:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsRealHero() then
		spawnedUnit:SetNightTimeVisionRange( HERO_NIGHTTIME_VISION_RANGE )
	end

	if spawnedUnit:IsCreature() then
		spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 * GAME_DIFFICULTY_FACTOR ) -- LEVEL SCALING VALUE FOR HP
		spawnedUnit:SetManaGain( 0 )
		spawnedUnit:SetHPRegenGain( 0 )
		spawnedUnit:SetManaRegenGain( 0 )
		if spawnedUnit:IsRangedAttacker() then
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.1 * GAME_DIFFICULTY_FACTOR ) -- LEVEL SCALING VALUE FOR DPS
		else
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.2 * GAME_DIFFICULTY_FACTOR ) -- LEVEL SCALING VALUE FOR DPS
		end
		spawnedUnit:SetArmorGain( 0 )
		spawnedUnit:SetMagicResistanceGain( 0 )
		spawnedUnit:SetDisableResistanceGain( 0 )
		spawnedUnit:SetAttackTimeGain( 0 )
		spawnedUnit:SetMoveSpeedGain( 0 )
		spawnedUnit:SetBountyGain( 0 )
		spawnedUnit:SetXPGain( 0 )
		
		if ( GAME_DIFFICULTY_FACTOR > 0 ) then
			spawnedUnit:CreatureLevelUp( 1 )
		end
	end

end

--------------------------------------------------------------------------------

function CHoldout:OnEntityKilled( event )
	local attackerUnit = EntIndexToHScript( event.entindex_attacker or -1 )
	local killedUnit = EntIndexToHScript( event.entindex_killed )

	if killedUnit and killedUnit:IsRealHero() and ( killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS ) then
		self:OnEntityKilled_PlayerHero( event )
		return
	end

	-- lasthit sound and particle
	if killedUnit and killedUnit:IsCreature() then
		if attackerUnit and attackerUnit:IsRealHero() then
			EmitSoundOnClient( "DarkMoonLastHit", attackerUnit:GetPlayerOwner() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/dark_moon/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, killedUnit, attackerUnit:GetPlayerOwner() ) )
		end
	end

	if killedUnit:GetUnitName() == "npc_dota_creature_rubick_melee_creep" then
		if RollPercentage( 5 ) then
			local newItem = CreateItem( "item_health_potion", nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( true )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			drop.Holdout_IsLootDrop = true
			
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
			newItem:LaunchLoot( true, 300, 0.75, dropTarget )
		end
		if RollPercentage( 5 ) then
			local newItem = CreateItem( "item_mana_potion", nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( true )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			drop.Holdout_IsLootDrop = true
			
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
			newItem:LaunchLoot( true, 300, 0.75, dropTarget )
		end
	end

	if killedUnit:GetUnitName() == "npc_dota_boss_rubick" then
		self:_AwardPoints()
		self:_Victory()
	end
end

--------------------------------------------------------------------------------

function CHoldout:OnEntityKilled_PlayerHero( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local attackerUnit = EntIndexToHScript( event.entindex_attacker )

	local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
	newItem:SetPurchaseTime( 0 )
	newItem:SetPurchaser( killedUnit )
	local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
	tombstone:SetContainedItem( newItem )
	tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
	FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	

	self:ResetKillsWithoutDying( killedUnit:GetPlayerOwnerID() )

	if attackerUnit then
		if attackerUnit:GetUnitName() == "npc_dota_boss_rubick" then
			self:OnBossKilledPlayer()
		end

		local gameEvent = {}
		gameEvent["player_id"] = killedUnit:GetPlayerID()
		gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = attackerUnit:GetUnitName()
		gameEvent["message"] = "#Frosthaven_KilledByCreature"
		FireGameEvent( "dota_combat_event_message", gameEvent )

		--self:FireDeathTaunt( attackerUnit )
	end
end

--------------------------------------------------------------------------------

-- When game state changes set state in script
function CHoldout:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if self._bDevMode then
			self:ForceAssignHeroes() 
		end
	end

	if nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		--Add Instruction Panel call here
		self:ForceAssignHeroes() -- @fixme: this doesn't work
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:RefreshShrines()
		self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds

		if self._bDevMode and self._nDevRoundNumber ~= nil then
			self:_TestRoundConsoleCommand( nil, self._nDevRoundNumber, self._nDevRoundDelay )
		end

	end
end

--------------------------------------------------------------------------------------------------------
--abilityname
--caster_entindex

function CHoldout:OnNonPlayerUsedAbility( event )
	local casterUnit = EntIndexToHScript( event.caster_entindex )
	if casterUnit then
		if casterUnit.SpellCastResult ~= nil then
			casterUnit.SpellCastResult( event.abilityname )
		end
	end
end

--------------------------------------------------------------------------------------------------------

function CHoldout:OnPlayerUsedAbility( event )
	local casterUnit = EntIndexToHScript( event.caster_entindex )
	if casterUnit and self._hRubick ~= nil then
		if casterUnit == self._hRubick then
			self._hRubick.SpellCastResult( event.abilityname )
		else
			if self._hRubick.EnemySpellCastResult ~= nil then
				self._hRubick.EnemySpellCastResult( casterUnit, event.abilityname )
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------

function CHoldout:OnItemPickedUp( event )
	if event.itemname == "item_throw_snowball" or event.itemname == "item_summon_snowman" or event.itemname == "item_decorate_tree" or event.itemname == "item_festive_firework" then
		local nAssociatedConsumable = GIFT_ASSOCIATED_CONSUMABLES[ event.itemname ]
		local hHeroWhoLooted = EntIndexToHScript( event.HeroEntityIndex )
		--print( string.format( "\"%s\" picked up item named \"%s\"", hHeroWhoLooted:GetUnitName(), event.itemname ) )
		--print( string.format( "   item has associated consumable #: %d", nAssociatedConsumable ) )

		if hHeroWhoLooted then
			local gameEvent = {}
			gameEvent["player_id"] = hHeroWhoLooted:GetPlayerID()
			gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
			gameEvent["locstring_value"] = event.itemname
			gameEvent["message"] = "#Frosthaven_PickedUpGift"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end

		-- Award every player a consumable
		local hAllHeroes = HeroList:GetAllHeroes()
		for i = 1, #hAllHeroes do
			local hHero = hAllHeroes[ i ]
			if hHero and hHero:IsRealHero() and hHero:IsTempestDouble() == false then
				local nPlayerID = hHero:GetPlayerID()
				PlayerResource:RecordConsumableAbilityChargeChange( nPlayerID, nAssociatedConsumable, 1 )

				EmitSoundOnClient( "GiftReceived", hHero:GetPlayerOwner() )
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
