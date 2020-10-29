
modifier_diretide_roshan_curse_debuff = class({})

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:GetTexture()
	return "roshan_halloween_angry"
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:GetEffectName()
	return "particles/roshan/roshan_curse/roshan_curse_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:OnCreated( kv )
	self.curse_dps_base = self:GetAbility():GetSpecialValueFor( "curse_dps_base" )
	self.curse_dps_max_hp_pct = self:GetAbility():GetSpecialValueFor( "curse_dps_max_hp_pct" )

	--[[
	self.curse_outgoing_damage_reduction = self:GetAbility():GetSpecialValueFor( "curse_outgoing_damage_reduction" )
	self.curse_movement_speed_slow = self:GetAbility():GetSpecialValueFor( "curse_movement_speed_slow" )
	]]

	if IsServer() then
		self.fDamageInterval = self:GetAbility():GetSpecialValueFor( "curse_dps_interval" )
		self:StartIntervalThink( self.fDamageInterval )
	end

	if IsClient() then
		if self:GetParent():GetPlayerOwnerID() == GetLocalPlayerID() then
			self.nClientParticleFX = ParticleManager:CreateParticle( "particles/roshan/roshan_curse/roshan_curse_debuff_screen.vpcf", PATTACH_CUSTOMORIGIN, nil )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:OnDestroy()
	if IsClient() then
		if self.nClientParticleFX ~= nil then
			ParticleManager:DestroyParticle( self.nClientParticleFX, false )
			self.nClientParticleFX = nil
		end
	end
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetParent():IsMagicImmune() == false and self:GetParent():IsInvulnerable() == false then
		local fPctDamage = ( self:GetParent():GetMaxHealth() * ( self.curse_dps_max_hp_pct / 100 ) )
		local fDamage = ( self.curse_dps_base + fPctDamage ) * ( self.fDamageInterval / 1 )

		local DamageInfo =
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = fDamage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
		}
		ApplyDamage( DamageInfo )

		SendOverheadEventMessage( self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_DAMAGE, self:GetParent(), fDamage, nil )

		-- Play inflict particle
		local nFXIndex = ParticleManager:CreateParticle( "particles/roshan/curse_dot/roshan_curse_bleed.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleFoWProperties( nFXIndex, 0, 2, 64.0 )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

--[[
function modifier_diretide_roshan_curse_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:GetModifierTotalDamageOutgoing_Percentage( params )
	return -self.curse_outgoing_damage_reduction
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_curse_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.curse_movement_speed_slow
end
]]

--------------------------------------------------------------------------------
