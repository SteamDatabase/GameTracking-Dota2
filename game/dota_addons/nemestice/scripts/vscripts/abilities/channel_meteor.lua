
channel_meteor = class({})

LinkLuaModifier( "modifier_meteor_channel", "modifiers/modifier_meteor_channel", LUA_MODIFIER_MOTION_VERTICAL )

--------------------------------------------------------------------------------

function channel_meteor:Precache( context )
end

--------------------------------------------------------------------------------

function channel_meteor:IsCosmetic()
	return true
end

--------------------------------------------------------------------------------

function channel_meteor:GetCastRangeBonus()
	return 0
end

--------------------------------------------------------------------------------

function channel_meteor:GetChannelTime()
	return self:GetMeteorChannelTime()
end

--------------------------------------------------------------------------------

function channel_meteor:GetMeteorChannelTime()
	return self:GetSpecialValueFor( "meteor_energy_interval" ) * ( 1.08 - self:GetRoundNumber() * 0.08 )
end

--------------------------------------------------------------------------------

function channel_meteor:GetRoundNumber()
	if IsServer() then
		return GameRules.Nemestice:GetRoundNumber()
	else
		local serverValues = CustomNetTables:GetTableValue( "globals", "values" );
		if serverValues ~= nil then
			return tonumber( serverValues[ "RoundNumber" ] )
		end
	end
end

--------------------------------------------------------------------------------

function channel_meteor:OnAbilityPhaseStart()
	if IsServer() == false then
		return true
	end

	self.meteor_energy_interval = self:GetMeteorChannelTime()
	self.meteor_energy_fx_interval = self:GetSpecialValueFor( "meteor_energy_fx_interval" )
	self.meteor_energy_value = self:GetSpecialValueFor( "meteor_energy_value" ) 
	self.meteor_energy_damage_hp_pct = self:GetSpecialValueFor( "meteor_energy_damage_hp_pct" )
	self.flNextTransferTime = GameRules:GetGameTime() + self.meteor_energy_interval
	self.flNextFXTime = GameRules:GetGameTime() + self.meteor_energy_fx_interval

	self.hMeteor = self:GetCursorTarget()
	self.hShardAbilityHero = self:GetCaster():FindAbilityByName( "hero_meteor_shard_pouch" )
	self.hShardAbilityMeteor = self.hMeteor:FindAbilityByName( "hero_meteor_shard_pouch" )

	self.bLoopingSound = false

	if self.hMeteor == nil or self.hMeteor:IsNull() or self.hMeteor:IsAlive() == false or self.hShardAbilityHero == nil or self.hShardAbilityMeteor == nil then
		return false
	end

	local kv = { meteor_channel_time=self.meteor_energy_interval }
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_meteor_channel", kv )

	return true
end

--------------------------------------------------------------------------------

function channel_meteor:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_meteor_channel" )
	end
end


--------------------------------------------------------------------------------

function channel_meteor:OnChannelThink( flInterval )
	if IsServer() then
		local bValidMeteor = self.hMeteor ~= nil and self.hMeteor:IsNull() == false and self.hMeteor:IsAlive() and self.hShardAbilityMeteor:GetShardCount() > 0

		if bValidMeteor then
			if GameRules:GetGameTime() > self.flNextTransferTime then
				local nCasterTeam = self:GetCaster():GetTeamNumber()
				local nShardsToGrant = self.meteor_energy_value
				local nShardsRemaining = self.hShardAbilityMeteor:GetShardCount()
				local bDrained = false
				if nShardsToGrant >= nShardsRemaining then
					nShardsToGrant = nShardsRemaining
					bDrained = true
				end

				self.flNextTransferTime = self.flNextTransferTime + self.meteor_energy_interval

				local szSource = "meteor_center"
				if self.hMeteor.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM then
					szSource = "meteor_side"
				end

				local hMeteorShard = GameRules.Nemestice:CreateMeteorShard( szSource, self.hMeteor:GetAbsOrigin(), nShardsToGrant )
				hMeteorShard:LaunchLootInitialHeight( true, 300, 300, 0.75, self:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 0, 50 ) ) )
				EmitSoundOn( "Nemestice.ShardRing", self.hMeteor )
				
				--self.hShardAbilityMeteor:SetCurrentAbilityCharges( self.hShardAbilityMeteor:GetShardCount() - self.meteor_energy_value )
				for i = 1,nShardsToGrant do
					self.hShardAbilityMeteor:RemoveShard()
				end
				self.hMeteor:SetHealth( self.hMeteor:GetMaxHealth() * ( ( nShardsRemaining - nShardsToGrant ) / ( self.hShardAbilityMeteor.nStartingShards or NEMESTICE_METEOR_CRASH_SITE_ENERGY_VALUE ) ) + self.meteor_energy_value )

				-- Keep track of who's grabbing shards.
				-- FIXME: catch case where team a chanenls a shard but team b picks it up?
				if self.hMeteor.nChannelTeam == nil then
					self.hMeteor.nChannelTeam = nCasterTeam
				elseif self.hMeteor.nChannelTeam ~= nCasterTeam and self.hMeteor.nChannelTeam ~= -1 then
					self.hMeteor.nChannelTeam = -1
				end

				if bDrained then
					if self.hMeteor.bDropNeutralItem then
						self.hMeteor.bDropNeutralItem = false
						local nRoundNumber = math.floor( GameRules.Nemestice:GetRoundNumber() / 2 + 0.51 )
						local szItemToDrop = GetPotentialNeutralItemDrop( nRoundNumber, nCasterTeam )
						local hHeroForDrop = self:GetCaster()
						if hHeroForDrop ~= nil and szItemToDrop ~= nil then
							local hItemPhysical = DropNeutralItemAtPositionForHero( szItemToDrop, self.hMeteor:GetAbsOrigin(), hHeroForDrop, nRoundNumber, true )
							if hItemPhysical ~= nil then
								-- Drop Neutral already does this - hItem:GetContainedItem():LaunchLootInitialHeight( false, 0, 200, 0.75, hHeroForDrop:GetAbsOrigin() )
								hItemPhysical.nHeroPlayerID = hHeroForDrop:GetPlayerOwnerID()
								hItemPhysical.nTeam = nCasterTeam
								hItemPhysical:GetContainedItem().nNeutralItemTeamNumber = nCasterTeam
								table.insert( GameRules.Nemestice.m_vecNeutralItemDrops, hItemPhysical )
							end
						end
					end
					if self.hMeteor.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
						if self.hMeteor.nChannelTeam == nCasterTeam then
							GameRules.Nemestice:GrantTeamBattlePoints( nCasterTeam, _G.BATTLE_POINT_DROP_FULL_CHANNEL, "full_channel" )
						end
					end
				end

				if self.meteor_energy_damage_hp_pct > 0 then
					local fDamage = ( self.meteor_energy_damage_hp_pct / 100 ) * self:GetCaster():GetMaxHealth()

					local DamageInfo =
					{
						victim = self:GetCaster(),
						attacker = self.hMeteor,
						ability = self,
						damage = fDamage,
						damage_type = DAMAGE_TYPE_PURE,
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
					}
					ApplyDamage( DamageInfo )
				end

				-- GameRules.Nemestice:ChangeMeteorEnergy( self:GetCaster():GetPlayerOwnerID(), 1, "crash_site_channel" )
			
				-- EmitMoonjuiceLastHitFX( 1, self:GetCaster(), self:GetCaster() )
				
				-- local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				-- ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hMeteor, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hMeteor:GetAbsOrigin(), true );
				-- ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true );
				-- ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		else
			self:EndChannel( false )
			self:GetCaster():RemoveModifierByName( "modifier_meteor_channel" )
			return
		end
		if GameRules:GetGameTime() > self.flNextFXTime then
			if bValidMeteor then
				self.flNextFXTime = self.flNextFXTime + self.meteor_energy_fx_interval
				-- Particle

				local vChannelPos = self.hMeteor:GetAbsOrigin() + Vector( 0, 0, 150 )

				local nFXIndex = ParticleManager:CreateParticle( "particles/gameplay/spring_meteor_channel/meteor_channel.vpcf", PATTACH_CUSTOMORIGIN, self.hMeteor )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, vChannelPos ) 
				ParticleManager:SetParticleControl( nFXIndex, 5, Vector( self.meteor_energy_fx_interval * 2, 0, 0 ) ) 
				--ParticleManager:SetParticleFoWProperties( nFXIndex, 0, 1, 50.f )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				if not self.bLoopingSound then
					EmitSoundOn( "Spring2021.MeteorChannel", self:GetCaster() )
					self.bLoopingSound = true
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function channel_meteor:OnChannelFinish( bInterrupted )
	StopSoundOn( "Spring2021.MeteorChannel", self:GetCaster() )
	self.bLoopingSound = false
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_meteor_channel" )

		local bValidMeteor = self.hMeteor ~= nil and self.hMeteor:IsNull() == false and self.hMeteor:IsAlive() and self.hShardAbilityMeteor:GetShardCount() > 0
		if bValidMeteor and not bInterrupted then
			self:GetCaster():CastAbilityOnTarget( self.hMeteor, self, self:GetCaster():GetPlayerOwnerID() )
		end
	end
end

--------------------------------------------------------------------------------

function channel_meteor:IsCosmetic( hEnt )
	return true
end

--------------------------------------------------------------------------------

function channel_meteor:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function channel_meteor:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function channel_meteor:IsHiddenAbilityCastable()
	return true
end

--------------------------------------------------------------------------------

function channel_meteor:OtherAbilitiesAlwaysInterruptChanneling()
	return true
end

--------------------------------------------------------------------------------

function channel_meteor:CastFilterResultTarget( hTarget )
	if hTarget == nil or ( hTarget:GetUnitName() ~= "npc_dota_crash_site_meteor" and hTarget:GetUnitName() ~= "npc_dota_crash_site_meteor_medium" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function channel_meteor:GetCustomCastErrorTarget( hTarget )
	return "#dota_hud_error_already_capturing"
end

--------------------------------------------------------------------------------

function channel_meteor:OnSpellStart()

end

