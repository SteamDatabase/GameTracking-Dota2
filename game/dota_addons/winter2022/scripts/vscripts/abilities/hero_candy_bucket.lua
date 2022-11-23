require( "winter2022_utility_functions" )

if hero_candy_bucket == nil then
	hero_candy_bucket = class({})
end

LinkLuaModifier( "modifier_hero_candy_bucket", "modifiers/gameplay/modifier_hero_candy_bucket", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_eat_regen", "modifiers/gameplay/modifier_candy_eat_regen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_eaten_recently", "modifiers/gameplay/modifier_candy_eaten_recently", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_scoring_blocked", "modifiers/gameplay/modifier_candy_scoring_blocked", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hero_candy_bucket:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function hero_candy_bucket:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function hero_candy_bucket:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function hero_candy_bucket:GetIntrinsicModifierName()
	return "modifier_hero_candy_bucket"
end

--------------------------------------------------------------------------------

function hero_candy_bucket:GetCandy()
	return self:GetCaster():GetModifierStackCount( "modifier_hero_candy_bucket", nil )
end

--------------------------------------------------------------------------------

function hero_candy_bucket:Precache( context )
	--CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), { candy_channel_time = 0.0 } )
	PrecacheResource( "particle", "particles/hw_fx/candy_carrying_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/hw_candy_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/bottle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", context )
	PrecacheResource( "particle", "particles/candy/candy_target_line.vpcf", context )
end

--------------------------------------------------------------------------------

function hero_candy_bucket:CastFilterResultTarget( hTarget )
	if self:GetCandy() == 0 then
		return UF_FAIL_CUSTOM
	end

	if self.nProjectileID ~= nil and ProjectileManager:IsValidProjectile( self.nProjectileID ) == true then
		return UF_FAIL_CUSTOM
	end

	if hTarget:IsBuilding() == true then
		-- building target
		-- no throwing to friendly buildings
		if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end

		if IsCandyBuilding( hTarget ) == false then
			-- don't allow throwing to buildings that don't have the candy bucket ability (like scarecrows)
			return UF_FAIL_CUSTOM
		elseif hTarget:IsInvulnerable() == true or hTarget:HasModifier( "modifier_fountain_glyph" ) then
			-- don't allow throwing at invulnerable candy buidlings
			return UF_FAIL_CUSTOM
		elseif self:GetCaster():HasModifier( "modifier_candy_scoring_blocked" )  then 
			return UF_FAIL_CUSTOM
		elseif hTarget:HasModifier( "modifier_building_roshan_attacking" ) then
			return UF_FAIL_CUSTOM
		else
			local hTargetBucket = hTarget:FindAbilityByName( "building_candy_bucket" )
			if hTargetBucket == nil 
					or hTargetBucket:IsNull() 
					--or hTargetBucket:GetCandy() >= hTargetBucket:GetCandyLimit() 
					then
				return UF_FAIL_CUSTOM
			end
		end
	else
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end


function hero_candy_bucket:GetCustomHudErrorMessage( nReason )
	if nReason == DOTA_INVALID_ORDER_CANT_CAST_NO_CHARGES then
		return "#dota_hud_error_no_candy"
	else
		return self.BaseClass.GetCustomHudErrorMessage( self, nReason )
	end
end
--------------------------------------------------------------------------------

function hero_candy_bucket:GetCustomCastErrorTarget( hTarget )
	if self:GetCandy() == 0 then
		return "#dota_hud_error_no_charges"
	end

	if self.nProjectileID ~= nil and ProjectileManager:IsValidProjectile( self.nProjectileID ) == true then
		return "#dota_hud_error_candy_already_in_flight"
	end

	if hTarget:IsBuilding() == true then
		-- building target
		-- no throwing to friendly buildings
		if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			return "#dota_hud_error_cant_cast_on_this_building"
		end

		if IsCandyBuilding( hTarget ) == false then
			-- don't allow throwing to buildings that don't have the candy bucket ability (like scarecrows)
			return "#dota_hud_error_cant_cast_on_buildings_without_candy_bucket"
		elseif hTarget:IsInvulnerable() == true or hTarget:HasModifier( "modifier_fountain_glyph" ) then
			-- don't allow throwing at invulnerable candy buidlings
			return "#dota_hud_error_invulnerable_candy_bucket_building"
		elseif self:GetCaster():HasModifier( "modifier_candy_scoring_blocked" )  then
			return "#dota_hud_error_candy_scoring_blocked"
		elseif hTarget:HasModifier( "modifier_building_roshan_attacking" ) then
			return "#dota_hud_error_cant_cast_roshan_attacking"
		else
			local hTargetBucket = hTarget:FindAbilityByName( "building_candy_bucket" )
			if hTargetBucket == nil then
				return "#dota_hud_error_cant_cast_on_buildings_no_ability"
			end
		end
	else
		return "#dota_hud_error_cant_throw_to_non_buildings"
	end

	-- only other failure is the bucket is full
	return "#dota_hud_error_building_candy_full"
end

-----------------------------------------------------------------------------


function hero_candy_bucket:GetChannelTime()
	if IsServer() then
		return 10000 -- we'll stop channeling when interrupted or out of candy, and client displays a custom channel bar anyway
	else
		local netTable = CustomNetTables:GetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ) )
		if netTable then
			return netTable[ "candy_channel_time" ] + 0.2
		end
	end


	return 10.0
end

-----------------------------------------------------------------------------

function hero_candy_bucket:GetChannelStartTime()
	if IsServer() == false and self.BaseClass.GetChannelStartTime(self) > 0.0 then
		local netTable = CustomNetTables:GetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ) )
		if netTable and netTable[ "start_time" ] then
			return netTable[ "start_time" ]
		end
	end

	return self.BaseClass.GetChannelStartTime(self)
end

-----------------------------------------------------------------------------

function hero_candy_bucket:OnSpellStart()
	if IsServer() then
		self.nCandyDelivered = 0
		self.candy_delivery_base_time = self:GetSpecialValueFor( "candy_delivery_base_time" )
		self.candy_delivery_increment = self:GetSpecialValueFor( "candy_delivery_increment" )
		self.candy_delivery_min_time = self:GetSpecialValueFor( "candy_delivery_min_time" )

		self.flCandyDeliveryInterval = self.candy_delivery_base_time
		local channel_data = { candy_channel_time = self.flCandyDeliveryInterval, start_time = GameRules:GetGameTime() }
		CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), channel_data )

		self.hTarget = self:GetCursorTarget()
		if self.hTarget == nil then
			return
		end

		self.fNextCandyDeliveryTime = GameRules:GetDOTATime( false, true ) + self.flCandyDeliveryInterval
		self.nThrownCandy = 0

		if self.hTarget:IsBuilding() then
			self.nCandyDeliveredPerInterval = 1
			local hTargetBucket = self.hTarget:FindAbilityByName( "building_candy_bucket" )
			if hTargetBucket ~= nil then
				hTargetBucket:PingCandyBucket( self:GetCaster() )
				self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_provide_vision", { duration = -1 } )
				self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_no_invisibility", { duration = -1 } )
			end
		else
			self:GetCaster():Interrupt()
			self:ThrowCandy()
		end

	end
end

--------------------------------------------------------------------------------

function hero_candy_bucket:SetCandy( nCandy )
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		nCandy = math.min(99, nCandy)
		printf( "HERO BUCKET: SetCandy to %d", nCandy )
		self:GetCaster():SetModifierStackCount( "modifier_hero_candy_bucket", nil, nCandy )

		-- update our max roshan ask if necessary
		CustomNetTables:SetTableValue( "candy_list", tostring( self:GetCaster():entindex() ), { entity_index = self:GetCaster():entindex(), candy_count = nCandy, update_time = GameRules:GetDOTATime( false, true ) } )
		GameRules.Winter2022:UpdateCurrentRoshanTrickOrTreatAsk( self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function hero_candy_bucket:ThrowCandy()
	if IsServer() then
		local vPos = self:GetCaster():GetAbsOrigin()
		vPos.z = vPos.z + 500

		local projectile =
		{
			Target = self.hTarget,
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/hw_fx/hw_candy_projectile.vpcf",
			iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
			vSourceLoc = vPos,
			bDodgeable = false,
			bProvidesVision = false,
			ExtraData = { amount = self:GetCandy() },
		}

		self.nProjectileID = ProjectileManager:CreateTrackingProjectile( projectile )

		EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), "CandyBucket.Throw", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function hero_candy_bucket:GetCastRangeBonus( hTarget, iPseudoCastRange )
	return 0
end

--------------------------------------------------------------------------------

function hero_candy_bucket:OnChannelThink( flInterval )
	if IsServer() then
		if GameRules.Winter2022:IsGameInProgress() == false then
			self:GetCaster():Interrupt()
			self:SetCandy( 0 )
			return
		end

		if self.hTarget == nil or self.hTarget:IsNull() or self.hTarget:IsAlive() == false then
			self:GetCaster():Interrupt()
			return
		end

		local nRange = self:GetEffectiveCastRange( self:GetCaster():GetAbsOrigin(), self.hTarget )
		if Dist2D( self.hTarget:GetAbsOrigin(), self:GetCaster():GetAbsOrigin() ) > nRange + 250 then
			self:GetCaster():Interrupt()
			return
		end

		if GameRules:GetDOTATime( false, true ) >= self.fNextCandyDeliveryTime then
			self:ThrowCandy()
			self.nThrownCandy = self.nThrownCandy + 1

			if self:GetCandy() - self.nThrownCandy <= 0 then
				self:GetCaster():Interrupt()
				return
			end

			self.flCandyDeliveryInterval = math.max(self.candy_delivery_min_time, self.flCandyDeliveryInterval - self.candy_delivery_increment)

			local flChannelThinkDelay = math.max(0, GameRules:GetDOTATime( false, true ) - self.fNextCandyDeliveryTime)
			self.fNextCandyDeliveryTime = GameRules:GetDOTATime( false, true ) + self.flCandyDeliveryInterval - flChannelThinkDelay

			local channel_data = { candy_channel_time = self.flCandyDeliveryInterval, start_time = GameRules:GetGameTime() - flChannelThinkDelay }
			CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), channel_data )
		end
	end
end

--------------------------------------------------------------------------------

function hero_candy_bucket:OnChannelFinish( bInterrupted )
	if IsServer() then
		self.nThrownCandy = 0
		self:GetCaster():RemoveModifierByName( "modifier_provide_vision" )
		self:GetCaster():RemoveModifierByName( "modifier_no_invisibility" )

		if self:GetCaster():IsStunned() or self:GetCaster():IsSilenced() or self:GetCaster():IsOutOfGame() then
			self:StartCooldown( self:GetSpecialValueFor( "damage_scoring_block_duration" ) )
		end

		-- Detect if a specific player interrupted our channel and reward quest progress
		-- Interruption from death covered in modifier_hero_candy_bucket:OnDeath
		if bInterrupted and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
			local hCaster = self:GetCaster()
			local bStunned = hCaster:IsStunned()
			local bSilenced = hCaster:IsSilenced()
			local bTaunted = hCaster:IsTaunted()
			local bFeared = hCaster:IsFeared()
			local bHexed = hCaster:IsHexed()
			local bFrozen = hCaster:IsFrozen()
			local bOutOfGame = hCaster:IsOutOfGame()
			local bCommandRestricted = hCaster:IsCommandRestricted()
			for _,hModifier in pairs( hCaster:FindAllModifiers() ) do
				local tState = {}
				if hModifier ~= nil and hModifier:IsNull() == false then
					hModifier:CheckStateToTable( tState )
					if ( bStunned and tState[tostring(MODIFIER_STATE_STUNNED)] == true )
						or ( bSilenced and tState[tostring(MODIFIER_STATE_SILENCED)] == true )
						or ( bTaunted and tState[tostring(MODIFIER_STATE_TAUNTED)] == true )
						or ( bFeared and tState[tostring(MODIFIER_STATE_FEARED)] == true )
						or ( bHexed and tState[tostring(MODIFIER_STATE_HEXED)] == true )
						or ( bFrozen and tState[tostring(MODIFIER_STATE_FROZEN)] == true )
						or ( bOutOfGame and tState[tostring(MODIFIER_STATE_OUT_OF_GAME)] == true )
						or ( bCommandRestricted and tState[tostring(MODIFIER_STATE_COMMAND_RESTRICTED)] == true )
					then
						local hStunCaster = hModifier:GetCaster()
						if hStunCaster ~= nil and hStunCaster:IsNull() == false and hStunCaster:GetTeamNumber() ~= hCaster:GetTeamNumber() and hStunCaster:IsOwnedByAnyPlayer() then
							--printf( "Candy Channel Interrupt! Hero %s is CC'd by %s", hCaster:GetUnitName(), hStunCaster:GetUnitName() )
							GameRules.Winter2022:GrantEventAction( hStunCaster:GetPlayerOwnerID(), "winter2022_interrupt_candy_channel", 1 )
						end
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------

function hero_candy_bucket:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
	if IsServer() then
		if GameRules.Winter2022:IsGameInProgress() == false then
			return true
		end

		if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false then
			self:GetCaster():Interrupt()
			return true
		end

		if hTarget:HasModifier( "modifier_building_roshan_attacking" ) then
			self:GetCaster():Interrupt()
			return true
		end

		if hTarget ~= nil and hTarget ~= self:GetCaster() then
			local nCandyCount = math.min( kv.amount, self:GetCandy() ) -- spoiler: yes, we *do* need the guard.

			if hTarget:IsRealHero() then
				local hTargetBucket = hTarget:FindAbilityByName( "hero_candy_bucket" )
				if hTargetBucket ~= nil then
					local nTotalCandy = hTargetBucket:GetCandy() + nCandyCount
					hTargetBucket:SetCandy( nTotalCandy )
					--print( "hero_candy_bucket:OnProjectileHit_ExtraData - gave " .. nCandyCount .. " candy to allied hero" )

					self:SetCandy( math.max( 0 , self:GetCandy() - nCandyCount ) )

					EmitSoundOn( "CandyBucket.LandOnHero", hTarget )
				end

				return true
			elseif hTarget:IsBuilding() then
				if hTarget:IsInvulnerable() == true or hTarget:FindModifierByName( "modifier_fountain_glyph" ) ~= nil then
					self:GetCaster():Interrupt()
					return true
				end

				local hTargetBucket = hTarget:FindAbilityByName( "building_candy_bucket" )
				if hTargetBucket ~= nil then
					if hTarget:HasModifier( "modifier_building_roshan_attacking" ) then
						return true
					end
					local nCandyLump = math.min( nCandyCount, ( self.nCandyDeliveredPerInterval == nil and 1 ) or math.max( 1, self.nCandyDeliveredPerInterval ) )
					if nCandyLump > 0 then
						local nRefund = hTargetBucket:SetCandy( hTargetBucket:GetCandy() + nCandyLump )
						local nScored = nCandyLump - nRefund
						self.nThrownCandy = math.max( 0, self.nThrownCandy - nScored )
						self:SetCandy( self:GetCandy() - nScored )
						if self:GetCaster().nCandyOnAcquire ~= nil then
							self:GetCaster().nCandyOnAcquire = math.max( 1, self:GetCaster().nCandyOnAcquire - nCandyLump + nRefund )
						end
						if nRefund > 0 then
							self:GetCaster():Interrupt()
						end
						local nPlayerID = self:GetCaster():GetPlayerOwnerID()
						GameRules.Winter2022:ScoreCandy( self:GetCaster():GetTeamNumber(), self:GetCaster(), nScored )

						if self:GetCandy() == 0 and GameRules.Winter2022.hRoshan ~= nil and self:GetCaster():FindModifierByName("modifier_enable_feedable_roshan_interact") ~= nil then
							-- if we are out of candy and were Roshan's target, allow him to switch targets
							GameRules.Winter2022.hRoshan.bMustAttackTarget = nil
						end

						GameRules.Winter2022:GrantEventAction( self:GetCaster():GetPlayerID(), "winter2022_score_candy", nCandyLump )
					end

					printf( "hero_candy_bucket:OnProjectileHit_ExtraData - turned candy in to bucket building" )
					
					self.nCandyDelivered = self.nCandyDelivered + 1
					if self.nCandyDelivered == 15 then
						GameRules.Winter2022:GetTeamAnnouncer( self:GetCaster():GetTeamNumber() ):OnCandyScoreHigh( self:GetCaster():GetPlayerID() )
					elseif self.nCandyDelivered == 1 then
						GameRules.Winter2022:GetTeamAnnouncer( self:GetCaster():GetTeamNumber() ):OnCandyScoreLow( self:GetCaster():GetPlayerID() )
					end

					EmitSoundOn( "CandyBucket.Score", hTarget )
				end

				return true
			elseif hTarget:GetUnitName() == "npc_dota_roshan_diretide" then
				local hBuff = hTarget:FindModifierByName( "modifier_diretide_roshan_passive" )
				if hBuff then
					local nRequest = hBuff:GetStackCount()
					local nThrowAmount = nCandyCount --math.min( nRequest, nCandyCount )
					print( '^^^Threw candy to Roshan = ' .. nThrowAmount )
					hBuff:AttemptEatCandy( nThrowAmount )
					self:SetCandy( math.max( 0, self:GetCandy() - nThrowAmount ) )

					local nPlayerID = self:GetCaster():GetPlayerOwnerID()

					GameRules.Winter2022:ModifyCandyStat("candy_fed", nPlayerID, nThrowAmount)

					if nRequest > nThrowAmount then
						local nFeedRoshanFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_ABSORIGIN, hTarget )
						ParticleManager:ReleaseParticleIndex( nFeedRoshanFX )

						EmitSoundOn( "CandyBucket.FeedRoshan", hTarget )
					else
						local nFedRoshanCompleteFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
						ParticleManager:ReleaseParticleIndex( nFedRoshanCompleteFX )
					end
				end

				return true
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------

function hero_candy_bucket:OnOwnerDied()
	if IsServer() then
		if self:GetCaster():WasKilledPassively() == true then
			local hBuff = self:GetCaster():FindModifierByName( "modifier_hero_candy_bucket" )
			if hBuff ~= nil then
				hBuff:DropCandy( nil )
			end
		end
	end
end

--------------------------------------------------------------------------------

function hero_candy_bucket:CalcCandyChannelTime()
	self.candy_delivery_base_time = self:GetSpecialValueFor( "candy_delivery_base_time" )
	self.candy_delivery_increment = self:GetSpecialValueFor( "candy_delivery_increment" )
	self.candy_delivery_min_time = self:GetSpecialValueFor( "candy_delivery_min_time" )

	flTotalChannelTime = 0
	local nCandy = self:GetCandy()
	local flCandyDeliveryTime = self.candy_delivery_base_time
	for i = 1, nCandy do
		flTotalChannelTime = flTotalChannelTime + flCandyDeliveryTime
		flCandyDeliveryTime = math.max(self.candy_delivery_min_time, flCandyDeliveryTime - self.candy_delivery_increment)
		if flCandyDeliveryTime == self.candy_delivery_min_time then
			flTotalChannelTime = flTotalChannelTime + (nCandy - i) * self.candy_delivery_min_time
			break
		end
	end

	return flTotalChannelTime
end