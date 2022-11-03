
modifier_mount_hit_cooldown = class({})

----------------------------------------------------------------------------------

function modifier_mount_hit_cooldown:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_mount_hit_cooldown:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_hit_cooldown:StatusEffectPriority()
	return 50
end

--------------------------------------------------------------------------------
