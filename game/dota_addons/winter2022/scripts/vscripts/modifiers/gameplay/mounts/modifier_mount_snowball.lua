if modifier_mount_snowball == nil then
	modifier_mount_snowball = class({})
end

--------------------------------------------------------------------------------

function modifier_mount_snowball:IsPermanent()
	return true
end

------------------------------------------------------------------------------

function modifier_mount_snowball:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_snowball:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_snowball:GetTexture()
	return "mount_snowball"
end