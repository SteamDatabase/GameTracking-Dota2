modifier_detect_invisible = class({})

--------------------------------------------------------------------------------

function modifier_detect_invisible:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_detect_invisible:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_detect_invisible:OnCreated( kv )
	self.flRadius = 5000
	if IsServer() then
		EmitSoundOn(  "Item.DropGemWorld", self:GetParent() )		
	end
end

-----------------------------------------------------------------------

function modifier_detect_invisible:GetEffectName()
    return "particles/creature_true_sight.vpcf"
end

--------------------------------------------------------------------------------

function modifier_detect_invisible:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

----------------------------------------

function modifier_detect_invisible:IsAura()
	return true
end

----------------------------------------

function modifier_detect_invisible:GetModifierAura()
	return  "modifier_truesight"
end

----------------------------------------

function modifier_detect_invisible:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

----------------------------------------

function modifier_detect_invisible:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------

function modifier_detect_invisible:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

----------------------------------------

function modifier_detect_invisible:GetAuraRadius()
	return self.flRadius
end
