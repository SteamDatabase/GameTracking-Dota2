bear_roar = class({})

--------------------------------------------------------------------------------

function bear_roar:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function bear_roar:OnAbilityPhaseStart()
	if IsServer() then
		self.taunt_duration = self:GetSpecialValueFor( "taunt_duration" )
		self.taunt_radius = self:GetSpecialValueFor( "taunt_radius" )
		
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/bear_aoe_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.taunt_radius, self.taunt_radius, self.taunt_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 0 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function bear_roar:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function bear_roar:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local taunt_params = { duration = self.taunt_duration }

		EmitSoundOn( "Hero_LoneDruid.SavageRoar.Cast", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.taunt_radius, self.taunt_radius, self.taunt_radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.taunt_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,hEnemy in pairs( enemies ) do
			if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
				hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_axe_berserkers_call", taunt_params )
			end
		end
	end
end


