
modifier_siltbreaker_immune_physical = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_physical:GetEffectName()
	--return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf"
	return "particles/act_2/immune_physical.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_physical:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_physical:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_physical:OnCreated( kv )
	if IsServer() then
		print( string.format( "modifier_siltbreaker_immune_physical - OnCreated; modifier's parent is: %s", self:GetParent():GetUnitName() ) )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_physical:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_physical:GetAbsoluteNoDamagePhysical( params )
	return 1
end

--------------------------------------------------------------------------------

