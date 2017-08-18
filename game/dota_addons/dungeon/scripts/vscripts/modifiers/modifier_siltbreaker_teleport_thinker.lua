
modifier_siltbreaker_teleport_thinker = class({})

-----------------------------------------------------------------------------

function modifier_siltbreaker_teleport_thinker:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.blast_damage = self:GetAbility():GetSpecialValueFor( "blast_damage" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.radius, 3.0, 1.0 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 16, Vector( 1, 0, 0 ) )
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_teleport_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector ( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Siltbreaker.Teleport.Impact", self:GetCaster() )

		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy ~= nil and hEnemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = hEnemy,
					attacker = self:GetCaster(),
					damage = self.blast_damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )

				local kv =
				{
					center_x = self:GetParent():GetOrigin().x,
					center_y = self:GetParent():GetOrigin().y,
					center_z = self:GetParent():GetOrigin().z,
					should_stun = true, 
					duration = 0.25,
					knockback_duration = 0.25,
					knockback_distance = 250,
					knockback_height = 125,
				}
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )
			end
		end

		FindClearSpaceForUnit( self:GetCaster(), self:GetParent():GetOrigin(), false )
		self:GetCaster():InterruptChannel()

		self:GetCaster():StartGesture( ACT_DOTA_CAST_REFRACTION )

		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------

