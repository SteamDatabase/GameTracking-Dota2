if modifier_mount_frosttoad == nil then
	modifier_mount_frosttoad = class({})
end

--------------------------------------------------------------------------------

function modifier_mount_frosttoad:IsPermanent()
	return true
end

------------------------------------------------------------------------------

function modifier_mount_frosttoad:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_frosttoad:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_frosttoad:GetTexture()
	return "mount_frosttoad"
end