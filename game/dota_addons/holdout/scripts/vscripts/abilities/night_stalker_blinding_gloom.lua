night_stalker_blinding_gloom = class({})
LinkLuaModifier( "modifier_night_stalker_blinding_gloom", "modifiers/modifier_night_stalker_blinding_gloom", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function night_stalker_blinding_gloom:OnSpellStart()	
	self.blinding_gloom_speed = self:GetSpecialValueFor( "blinding_gloom_speed" )
	self.blinding_gloom_width_initial = self:GetSpecialValueFor( "blinding_gloom_width_initial" )
	self.blinding_gloom_width_end = self:GetSpecialValueFor( "blinding_gloom_width_end" )
	self.blinding_gloom_distance = self:GetSpecialValueFor( "blinding_gloom_distance" )
	self.blinding_gloom_damage = self:GetSpecialValueFor( "blinding_gloom_damage" ) 
	self.duration = self:GetSpecialValueFor( "duration" ) 
	self.vision_radius = self:GetSpecialValueFor( "vision_radius" ) 
	self.range = self:GetSpecialValueFor( "range" )

	EmitSoundOn( "Hero_NightStalker.Void.Cast", self:GetCaster() )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.blinding_gloom_speed = self.blinding_gloom_speed * ( self.blinding_gloom_distance / ( self.blinding_gloom_distance - self.blinding_gloom_width_initial ) )

	self.nCarrionSwarmFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.nCarrionSwarmFXIndex, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.nCarrionSwarmFXIndex, 1, vDirection * self.blinding_gloom_speed )
	ParticleManager:SetParticleControl( self.nCarrionSwarmFXIndex, 2, Vector( self.blinding_gloom_width_initial, self.blinding_gloom_width_end, 0 ) )
	ParticleManager:SetParticleControl( self.nCarrionSwarmFXIndex, 4, Vector( 2.5, 0, 0 ) )

	local info = {
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.blinding_gloom_width_initial,
		fEndRadius = self.blinding_gloom_width_end,
		vVelocity = vDirection * self.blinding_gloom_speed,
		fDistance = self.blinding_gloom_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_NightStalker.Void", self:GetCaster() )
end

--------------------------------------------------------------------------------

function night_stalker_blinding_gloom:OnProjectileThink( vLocation )
	ParticleManager:SetParticleControl( self.nCarrionSwarmFXIndex, 2, Vector( self.blinding_gloom_width_end, self.blinding_gloom_width_end, 0 ) )
end

--------------------------------------------------------------------------------

function night_stalker_blinding_gloom:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.blinding_gloom_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_night_stalker_blinding_gloom", { duration = self.duration } )

		ApplyDamage( damage )

		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget ) -- particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm_impact.vpcf
		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

	end

	ParticleManager:DestroyParticle( self.nCarrionSwarmFXIndex, true )
	ParticleManager:ReleaseParticleIndex( self.nCarrionSwarmFXIndex )

	return false
end

--------------------------------------------------------------------------------