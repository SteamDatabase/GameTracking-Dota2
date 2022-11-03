if modifier_diretide_bucket_soldier_passive == nil then
	modifier_diretide_bucket_soldier_passive = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------

--function modifier_diretide_bucket_soldier_passive:GetEffectName()
--	return "particles/units/creatures/bucket_guardian/bucket_guardian_ambient.vpcf"
--end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:CheckState()
	if IsServer() == false then
		return
	end

	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:OnAttackLanded( params )
	if IsServer() == false then
		return
	end

	local hAttacker = params.attacker
	if ( hAttacker == nil ) or hAttacker:IsNull() or ( hAttacker ~= self:GetParent() ) then
		return
	end

	local hVictim = params.target
	if hVictim == nil or hVictim:IsNull() then
		return
	end

	-- kill illusions
	if hVictim:IsIllusion() and not hVictim:IsStrongIllusion() then
		hVictim:Kill( self:GetAbility(), self:GetCaster() )
		return
	end

	-- kill wards
	if hVictim:IsWard() or hVictim:IsHeroWard() then
		hVictim:Kill( self:GetAbility(), self:GetCaster() )
		return
	end
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:GetModifierProvidesFOWVision( params )
	if params.target ~= nil and ( params.target:GetTeamNumber() == DOTA_TEAM_GOODGUYS or params.target:GetTeamNumber() == DOTA_TEAM_BADGUYS or params.target:GetTeamNumber() == DOTA_TEAM_CUSTOM_1 ) then
		return 1
	end
	return 0
end
