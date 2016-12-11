lina_dragon_slave_lua = class({})

--------------------------------------------------------------------------------

function lina_dragon_slave_lua:OnSpellStart()
	self.dragon_slave_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	self.dragon_slave_width_initial = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	self.dragon_slave_width_end = self:GetSpecialValueFor( "dragon_slave_width_end" )
	self.dragon_slave_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	self.dragon_slave_damage = self:GetSpecialValueFor( "dragon_slave_damage" ) 

	EmitSoundOn( "Hero_Lina.DragonSlave.Cast", self:GetCaster() )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.dragon_slave_speed = self.dragon_slave_speed * ( self.dragon_slave_distance / ( self.dragon_slave_distance - self.dragon_slave_width_initial ) )

	local info = {
		EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.dragon_slave_width_initial,
		fEndRadius = self.dragon_slave_width_end,
		vVelocity = vDirection * self.dragon_slave_speed,
		fDistance = self.dragon_slave_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Lina.DragonSlave", self:GetCaster() )
end

--------------------------------------------------------------------------------

function lina_dragon_slave_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.dragon_slave_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )

		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------