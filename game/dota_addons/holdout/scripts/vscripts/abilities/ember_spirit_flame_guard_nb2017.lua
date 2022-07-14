ember_spirit_flame_guard_nb2017 = class({})

--------------------------------------------------------------------------------

function ember_spirit_flame_guard_nb2017:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget == nil or hTarget:IsInvulnerable() then
		return
	end

	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ember_spirit_flame_guard", { duration = self:GetSpecialValueFor( "duration" ) } )
end

--------------------------------------------------------------------------------

function ember_spirit_flame_guard_nb2017:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

