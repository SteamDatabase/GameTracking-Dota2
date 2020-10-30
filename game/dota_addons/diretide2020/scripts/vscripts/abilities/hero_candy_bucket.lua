if hero_candy_bucket == nil then
	hero_candy_bucket = class({})
end

LinkLuaModifier( "modifier_hero_candy_bucket", "modifiers/gameplay/modifier_hero_candy_bucket", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_eat_regen", "modifiers/gameplay/modifier_candy_eat_regen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_eaten_recently", "modifiers/gameplay/modifier_candy_eaten_recently", LUA_MODIFIER_MOTION_NONE )

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
	local nCharges = self:GetCurrentAbilityCharges()
	if nCharges > 999 then -- will detect the default of 9999
		nCharges = 0
	end
	return nCharges
end

--------------------------------------------------------------------------------

function hero_candy_bucket:Precache( context )
	--CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), { candy_channel_time = 0.0 } )
	PrecacheResource( "particle", "particles/hw_fx/candy_carrying_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/hw_candy_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/bottle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", context )
end

--------------------------------------------------------------------------------

function hero_candy_bucket:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() == "npc_dota_roshan_diretide" then
		if hTarget:HasModifier( "modifier_diretide_roshan_passive" ) then
			local nRequest = hTarget:GetModifierStackCount( "modifier_diretide_roshan_passive", nil )
			if nRequest == 0 then
				return UF_FAIL_CUSTOM
			else
				local serverValues = CustomNetTables:GetTableValue( "globals", "values" );
				if serverValues ~= nil then
					local nTeam = serverValues[ "TrickOrTreatTeam" ]
					if nTeam == self:GetCaster():GetTeamNumber() then
						return UF_SUCCESS;
					else
						return UF_FAIL_CUSTOM;
					end
				end
				return UF_SUCCESS 
			end
		end
		return UF_FAIL_CUSTOM
	end

	if self:GetCandy() == 0 then
		return UF_FAIL_CUSTOM
	end

	if self:GetCaster() == hTarget then
		if DIRETIDE_CANDY_CAN_BE_EATEN == true then
			local bHasEatenRecently = hTarget:HasModifier( "modifier_candy_eaten_recently" )
			if bHasEatenRecently == true then
				return UF_FAIL_CUSTOM
			end
		else
			return UF_FAIL_CUSTOM
		end
	end

	if hTarget:IsBuilding() and hTarget:GetUnitName() ~= "home_candy_bucket" then
		return UF_FAIL_CUSTOM
	end

	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return UF_FAIL_CUSTOM
	end

	if hTarget:IsCreep() then
		return UF_FAIL_CUSTOM
	end

	if hTarget:IsIllusion() then
		return UF_FAIL_CUSTOM
	end

	if self.nProjectileID ~= nil and ProjectileManager:IsValidProjectile( self.nProjectileID ) == true then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function hero_candy_bucket:GetCustomCastErrorTarget( hTarget )
	if self:GetCandy() == 0 then
		return "#dota_hud_error_no_charges"
	end

	if self:GetCaster() == hTarget then
		if DIRETIDE_CANDY_CAN_BE_EATEN == true then
			local bHasEatenRecently = hTarget:HasModifier( "modifier_candy_eaten_recently" )
			if bHasEatenRecently == true then
				return "#dota_hud_error_candy_eaten_recently"
			end
		else
			return "#dota_hud_error_cant_cast_on_self"
		end
	end

	if hTarget:GetUnitName() == "npc_dota_roshan_diretide" then
		local serverValues = CustomNetTables:GetTableValue( "globals", "values" );
		if serverValues ~= nil then
			local nTeam = serverValues[ "TrickOrTreatTeam" ]
			if nTeam == self:GetCaster():GetTeamNumber() then
				return "#dota_hud_error_cant_cast_on_roshan_not_hungry"
			else
				return "#dota_hud_error_cant_cast_on_roshan_wrong_team"
			end
		end
	end

	if hTarget:IsBuilding() and hTarget:GetUnitName() ~= "home_candy_bucket" then
		return "#dota_hud_error_cant_cast_on_this_building"
	end

	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return "#dota_hud_error_cant_cast_on_enemy"
	end

	if hTarget:IsCreep() then
		return "#dota_hud_error_cant_cast_on_creep"
	end

	if hTarget:IsIllusion() then
		return "#dota_hud_error_cant_cast_on_illusions"
	end

	if self.nProjectileID ~= nil and ProjectileManager:IsValidProjectile( self.nProjectileID ) == true then
		return "#dota_hud_error_candy_already_in_flight"
	end

	return ""
end

-----------------------------------------------------------------------------


function hero_candy_bucket:GetChannelTime()
	local netTable = CustomNetTables:GetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ) )
	if netTable then
		return netTable[ "candy_channel_time" ] * 1.2
	end

	return 10.0
end

-----------------------------------------------------------------------------

function hero_candy_bucket:OnSpellStart()
	if IsServer() then
		self.candy_delivery_interval = self:GetSpecialValueFor( "candy_delivery_interval" )

		CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), { candy_channel_time = self:GetCurrentAbilityCharges() * self.candy_delivery_interval + 0.2 } )
		self.hTarget = self:GetCursorTarget()
		if self.hTarget == nil then
			return
		end

		local nCurrentCharges = self:GetCandy()
		self:SetCurrentAbilityCharges( nCurrentCharges + 1 )

		self.fNextCandyDeliveryTime = GameRules:GetDOTATime( false, true ) + self.candy_delivery_interval

		if self.hTarget:GetUnitName() ~= "home_candy_bucket" then
			self:GetCaster():Interrupt()
		else
			self.nCandyDeliveredPerInterval = 1
			self.nChannelThrows = self:GetCandy() - 1
		end

		self:ThrowCandy()
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

function hero_candy_bucket:OnChannelThink( flInterval )
	if IsServer() then
		if GameRules.Diretide:IsRoundInProgress() == false then
			self:GetCaster():Interrupt()
			self.nChannelThrows = 0
			self:SetCurrentAbilityCharges( 0 )
			return
		end

		if GameRules:GetDOTATime( false, true ) >= self.fNextCandyDeliveryTime then
			
			self.nChannelThrows = self.nChannelThrows - 1
			self:ThrowCandy()

			if self.nChannelThrows <= 0 then
				self:GetCaster():Interrupt()
				return
			end

			self.fNextCandyDeliveryTime = GameRules:GetDOTATime( false, true ) + self.candy_delivery_interval
		end
	end
end

--------------------------------------------------------------------------------

function hero_candy_bucket:OnChannelFinish( bInterrupted )
	if IsServer() then
		if bInterrupted then
			--printf( "  channel was interrupted" )
		end
	end
end
--------------------------------------------------------------------------------

function hero_candy_bucket:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
	if IsServer() then
		if GameRules.Diretide:IsRoundInProgress() == false then
			return true
		end

		if hTarget ~= nil and hTarget ~= self:GetCaster() then
			local nCandyCount = math.min( kv.amount, self:GetCandy() ) -- spoiler: yes, we *do* need the guard.

			if hTarget:IsRealHero() then
				local hTargetBucket = hTarget:FindAbilityByName( "hero_candy_bucket" )
				if hTargetBucket ~= nil then
					local nTotalCandy = hTargetBucket:GetCandy() + nCandyCount
					hTargetBucket:SetCurrentAbilityCharges( nTotalCandy )
					--print( "hero_candy_bucket:OnProjectileHit_ExtraData - gave " .. nCandyCount .. " candy to allied hero" )

					self:SetCurrentAbilityCharges( math.max( 0 , self:GetCandy() - nCandyCount ) )

					EmitSoundOn( "CandyBucket.LandOnHero", hTarget )
				end

				return true
			elseif hTarget:GetUnitName() == "home_candy_bucket" then
				local nCandyLump = math.min( nCandyCount, ( self.nCandyDeliveredPerInterval == nil and 1 ) or math.max( 1, self.nCandyDeliveredPerInterval ) )
				self:SetCurrentAbilityCharges( math.max( 0, self:GetCandy() - nCandyLump ) )
				if nCandyLump > 0 then
					GameRules.Diretide:ScoreCandy( self:GetCaster():GetTeamNumber(), self:GetCaster(), nCandyLump )
				end
				--printf( "hero_candy_bucket:OnProjectileHit_ExtraData - turned candy in to bucket building" )

				EmitSoundOn( "CandyBucket.Score", hTarget )

				return true
			elseif hTarget:GetUnitName() == "npc_dota_roshan_diretide" then
				local hBuff = hTarget:FindModifierByName( "modifier_diretide_roshan_passive" )
				if hBuff then
					local nRequest = hBuff:GetStackCount()
					local nThrowAmount = math.min( nRequest, nCandyCount )
					hBuff:SetStackCount( nRequest - nThrowAmount  )
					self:SetCurrentAbilityCharges( math.max( 0, self:GetCandy() - nThrowAmount ) )

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

function hero_candy_bucket:OnChargeCountChanged()
	if IsServer() then
		if self:GetCandy() > 10 then
			--printf( "OnChargeCountChanged - current charges: %d", self:GetCurrentCharges )
		end
	end
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
