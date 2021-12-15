
modifier_low_hp_outgoing_damage = class({})

-----------------------------------------------------------------------------------------

function modifier_low_hp_outgoing_damage:IsPurgable()
	return false
end


----------------------------------------------------------------------------------------

function modifier_low_hp_outgoing_damage:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf", context )
end

----------------------------------------

function modifier_low_hp_outgoing_damage:OnCreated( kv )
	self.health_threshold_pct = 20
end

----------------------------------------

function modifier_low_hp_outgoing_damage:GetEffectName()
	if self:GetParent():GetHealthPercent() < self.health_threshold_pct then
		return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
	else
		return ""
end

--------------------------------------------------------------------------------

function modifier_low_hp_outgoing_damage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_low_hp_outgoing_damage:GetModifierTotalDamageOutgoing_Percentage( params )
	if self:GetParent():GetHealthPercent() < self.health_threshold_pct then
		return self:GetStackCount()
	else
		return 0
	end
end



--------------------------------------------------------------------------------
function modifier_low_hp_outgoing_damage:IsPermanent()
	return true
end
