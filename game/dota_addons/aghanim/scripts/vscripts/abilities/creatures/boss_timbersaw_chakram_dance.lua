
require( "utility_functions" )

boss_timbersaw_chakram_dance = class({})
LinkLuaModifier( "modifier_boss_timbersaw_chakram_dance", "modifiers/creatures/modifier_boss_timbersaw_chakram_dance", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------

function boss_timbersaw_chakram_dance:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram_aghs.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_sand_king_channel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram_hit.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_iceblast_half.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram.vpcf", context )
end

-------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:OnAbilityPhaseStart()
	if IsServer() then
		--EmitSoundOn( "SandKingBoss.Epicenter.spell", self:GetCaster() )
		if IsGlobalAscensionCaster( self:GetCaster() ) == false then
			self.nChannelFX = ParticleManager:CreateParticle( "particles/test_particle/dungeon_sand_king_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		end
	end
	return true
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.nChannelFX ~= nil then
			ParticleManager:DestroyParticle( self.nChannelFX, false )
		end
	end
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:GetPlaybackRateOverride()
	return 1
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:OnSpellStart()
	if IsServer() then
		self.hChakramAbility = self:GetCaster():FindAbilityByName( "shredder_chakram" )
		if self.hChakramAbility == nil then 
			self.hChakramAbility = self
		end
		self.pass_slow_duration = self.hChakramAbility:GetSpecialValueFor( "pass_slow_duration" )
		self.pass_damage = self.hChakramAbility:GetSpecialValueFor( "pass_damage" )
		self.radius = self.hChakramAbility:GetSpecialValueFor( "radius" )
		self.is_ascension_ability = 0
		if IsGlobalAscensionCaster( self:GetCaster() ) == true then
			self.is_ascension_ability = 1
		end

		local kv = {}
		kv[ "is_ascension_ability" ] = self.is_ascension_ability
		kv[ "radius"] = self.radius
		self.hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_boss_timbersaw_chakram_dance", kv )
	end
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_boss_timbersaw_chakram_dance" )
		self.hBuff = nil
		if self.nChannelFX ~= nil then
			ParticleManager:DestroyParticle( self.nChannelFX, false )
		end
	end
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:OnProjectileThink( vLocation )
	if IsServer() then
		GridNav:DestroyTreesAroundPoint( vLocation, self.radius, true )
	end
end

--------------------------------------------------------------------------------

function boss_timbersaw_chakram_dance:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if hTarget == nil then
			if self.hBuff == nil then
				return true
			end
			local Chakram = self.hBuff:GetChakram( nProjectileHandle )
			if Chakram == nil then
			--	print( "error, chakram is nil? ")
				return true
			end
			if Chakram.bReturning == false then
				self.hBuff:ReturnChakram( Chakram, vLocation )
				return true
			end
		elseif hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
			local damageInfo =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.pass_damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self.hChakramAbility,
			}
			if self.is_ascension_ability == 1 then
				damageInfo.damage = damageInfo.damage * hTarget:GetMaxHealth() / 100.0
			end

			ApplyDamage( damageInfo )

			hTarget:AddNewModifier( self:GetCaster(), self.hChakramAbility, "modifier_shredder_chakram_debuff", { duration = self.pass_slow_duration } )
			EmitSoundOn( "Boss_Timbersaw.Chakram.Target", hTarget )
			if hTarget:IsHero() then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_shredder/shredder_chakram_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			return false
		end
	end

	return true
end

-----------------------------------------------------------------------------

ascension_timbersaw_chakram_dance = boss_timbersaw_chakram_dance