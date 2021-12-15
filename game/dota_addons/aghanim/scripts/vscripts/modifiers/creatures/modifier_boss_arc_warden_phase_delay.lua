
if modifier_boss_arc_warden_phase_delay == nil then
	modifier_boss_arc_warden_phase_delay = class({})
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_phase_delay:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_phase_delay:IsPurgable()
	return false
end
