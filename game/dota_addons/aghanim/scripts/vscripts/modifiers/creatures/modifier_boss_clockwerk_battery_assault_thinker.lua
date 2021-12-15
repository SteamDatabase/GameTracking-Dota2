
modifier_boss_clockwerk_battery_assault_thinker = class({})

---------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault_thinker:OnCreated( kv )
	self.ground_radius = self:GetAbility():GetSpecialValueFor( "ground_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.debuff_duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )

	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/boss_earthshaker/quake_marker.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.ground_radius, -self.ground_radius, -self.ground_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 2, Vector( self:GetRemainingTime(), 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )

		EmitSoundOn( "Boss_Clockwerk.Battery_Assault_Launch", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault_thinker:OnDestroy()
	if not IsServer() then
		return -1
	end

	ParticleManager:DestroyParticle( self.nPreviewFX, false )

	local enemies = Util_FindEnemiesAroundUnit( self:GetParent(), self.ground_radius )

	for _, enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsAttackImmune() == false then
			local kv_stun = { duration = self.debuff_duration }
			enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", kv_stun )
			
			local damage = 
			{
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(),
			}
	
			ApplyDamage( damage )
		end
	end

	EmitSoundOn( "Boss_Clockwerk.Battery_Assault_Impact", self:GetParent() )

	local nQuakeFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nQuakeFX, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( nQuakeFX, 1, Vector( self.ground_radius, self.ground_radius, self.ground_radius ) )
	ParticleManager:ReleaseParticleIndex( nQuakeFX )
end

--------------------------------------------------------------------------------
