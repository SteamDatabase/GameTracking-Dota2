
modifier_boss_arc_warden_absolute_no_cc = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_absolute_no_cc:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_absolute_no_cc:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_absolute_no_cc:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_absolute_no_cc:OnCreated( kv )
	if IsServer() then
		self:GetParent().bAbsoluteNoCC = true
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_absolute_no_cc:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,
		[MODIFIER_STATE_TAUNTED] = false,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}

	if IsServer() then
		-- root the arc warden while in the magnetic field
		if self:GetParent():FindModifierByName( 'modifier_aghsfort_arc_warden_boss_magnetic_field_attack_speed' ) ~= nil then
			state[MODIFIER_STATE_ROOTED] = true
		end
	end

	return state
end
