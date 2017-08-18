
modifier_siltbreaker_immune_magical = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_magical:GetEffectName()
	--return "particles/items_fx/black_king_bar_avatar.vpcf"
	return "particles/act_2/immune_magical.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_magical:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_magical:OnCreated( kv )
	if IsServer() then
		print( string.format( "modifier_siltbreaker_immune_magical - OnCreated; modifier's parent is: %s", self:GetParent():GetUnitName() ) )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_magical:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_immune_magical:GetAbsoluteNoDamageMagical( params )
	return 1
end

--------------------------------------------------------------------------------

