modifier_temple_guardian_statue = class({})

-----------------------------------------------------------------------------

function modifier_temple_guardian_statue:IsHidden()
	return true
end

-------------------------------------------------------------------

function modifier_temple_guardian_statue:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	return state
end

-------------------------------------------------------------------

function modifier_temple_guardian_statue:OnCreated( kv )
	if IsServer() then
		local vAngles = self:GetParent():GetAnglesAsVector()
		self:GetParent():SetAngles( vAngles.x, vAngles.y - 90.0, vAngles.z )
		self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_7 )
	end
end

--------------------------------------------------------------------------------

function modifier_temple_guardian_statue:OnDestroy()
	if IsServer() then
	end
end

