if modifier_diretide_bucket_soldier_passive == nil then
	modifier_diretide_bucket_soldier_passive = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:GetEffectName()
	return "particles/units/creatures/bucket_guardian/bucket_guardian_ambient.vpcf"
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:CheckState()
	if IsServer() == false then
		return
	end

	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end
