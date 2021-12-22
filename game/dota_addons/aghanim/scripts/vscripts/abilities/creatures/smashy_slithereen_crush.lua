
smashy_slithereen_crush = class({})

----------------------------------------------------------------------------------------

function smashy_slithereen_crush:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/wyvern_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/treant_miniboss/entangle_ground_preview_cast.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context )
end

-----------------------------------------------------------------------------

function smashy_slithereen_crush:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function smashy_slithereen_crush:GetPlaybackRateOverride()
	return 0.40
end


-----------------------------------------------------------------------------

function smashy_slithereen_crush:OnAbilityPhaseStart()
	if IsServer() == false then
		return
	end

	self.nSelfFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_slardar/slardar_crush_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	self.crush_radius = self:GetSpecialValueFor( "crush_radius" )

	local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/wyvern_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( self:GetCaster():GetAbsOrigin(), self:GetCaster() ) )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.crush_radius, 1.6, 1 ) )
	ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 165, 242, 243 ) )
	ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true 
end

-----------------------------------------------------------------------------

function smashy_slithereen_crush:OnAbilityPhaseInterrupted()
	if IsServer() == false then
		return
	end

	ParticleManager:DestroyParticle( self.nSelfFX, false )
	--ParticleManager:DestroyParticle( self.nTargetPosFX, true )
end

-----------------------------------------------------------------------------

function smashy_slithereen_crush:OnSpellStart()
	if IsServer() == false then
		return
	end

	self.crush_radius = self:GetSpecialValueFor( "crush_radius" )
	self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
	self.crush_damage = self:GetSpecialValueFor( "crush_damage" ) 
	self.crush_extra_slow_duration = self:GetSpecialValueFor( "crush_extra_slow_duration" )
	self.puddle_duration = self:GetSpecialValueFor( "puddle_duration" )

	ParticleManager:DestroyParticle( self.nSelfFX, false )
	--ParticleManager:DestroyParticle( self.nTargetPosFX, true )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.crush_radius, self.crush_radius, self.crush_radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Slardar.Slithereen_Crush", self:GetCaster() )

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.crush_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
		if enemy == nil or enemy:IsNull() then 
			goto continue
		end

		if enemy:IsInvulnerable() then 
			goto continue 
		end

		if enemy:IsMagicImmune() then 
			goto continue 
		end

		enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_slithereen_crush", { duration = self.stun_duration + self.crush_extra_slow_duration } )

		local damage = 
		{
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self.crush_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
		}

		ApplyDamage( damage )

		::continue::
	end

	CreateModifierThinker( self:GetCaster(), self, "modifier_slardar_puddle_thinker", { duration = self.puddle_duration }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )

end

-----------------------------------------------------------------------------

bashy_slithereen_crush = smashy_slithereen_crush