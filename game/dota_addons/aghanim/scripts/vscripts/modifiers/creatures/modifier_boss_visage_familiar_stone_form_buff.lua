modifier_boss_visage_familiar_stone_form_buff = class({})

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:GetPriority( )
	return MODIFIER_PRIORITY_HIGH + 6
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:GetStatusEffectName() 
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"; 
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:AddCustomTransmitterData()
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:HandleCustomTransmitterData( entry )
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:OnCreated( kv )
	self.stun_delay = self:GetAbility():GetSpecialValueFor( "stun_delay" )
	self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	if IsServer() then
		self.bStunned = false
		self:SetStackCount( 0 )
		self:StartIntervalThink( self.stun_delay )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:OnIntervalThink()
	if IsServer() then
		if not self.bStunned then
			self.bStunned = true
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_stone_form.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.damage_radius, 1, 1 ) )
			ParticleManager:SetParticleFoWProperties( nFXIndex, 0, -1, self.damage_radius )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Visage_Familar.StoneForm.Cast", self:GetParent() )

			
			self:GetParent():Heal( 99999, self:GetAbility() )
			self:SendBuffRefreshToClients()

			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
				
					EmitSoundOn( "Visage_Familar.StoneForm.Stun", enemy )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
				end
			end

			
		end

		self:IncrementStackCount()
	end
end

-- --------------------------------------------------------------------------------

-- function modifier_boss_visage_familiar_stone_form_buff:DeclareFunctions()
-- 	local funcs = 
-- 	{
-- 		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
-- 		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
-- 	}
-- 	return funcs
-- end

-- --------------------------------------------------------------------------------

-- function modifier_boss_visage_familiar_stone_form_buff

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_stone_form_buff:CheckState()
	local bOnGround = self:GetStackCount() > 1
	local state = {}
	state[MODIFIER_STATE_FROZEN] = self:GetStackCount() > 5
	state[MODIFIER_STATE_STUNNED] = true
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_FLYING] = ( not bOnGround )
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	state[MODIFIER_STATE_PROVIDES_VISION] = true
	return state
end
