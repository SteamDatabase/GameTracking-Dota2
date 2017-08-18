
modifier_item_glimmerdark_shield_prism = class({})

--------------------------------------------------------------------------------

--[[
function modifier_item_glimmerdark_shield_prism:GetEffectName()
	return "particles/act_2/gleam.vpcf"
end
]]

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:GetTexture()
	return "item_glimmerdark_shield"
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:OnCreated( kv )
	self.prism_bonus_magic_dmg = self:GetAbility():GetSpecialValueFor( "prism_bonus_magic_dmg" )

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/gleam.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( 100, 100, 100 ) )
	end
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:GetAbsoluteNoDamagePhysical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self.prism_bonus_magic_dmg
end 

--------------------------------------------------------------------------------

