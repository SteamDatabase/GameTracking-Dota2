
modifier_boss_arc_warden_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_passive:CheckState()
	local state = {}

	if IsServer() then
		-- root the arc warden while in the magnetic field
		if self:GetParent():FindModifierByName( 'modifier_aghsfort_arc_warden_boss_magnetic_field_attack_speed' ) ~= nil then
			state[MODIFIER_STATE_ROOTED] = true
		end
	end

	return state
end
