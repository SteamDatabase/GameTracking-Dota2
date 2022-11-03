if modifier_mount_ogreseal == nil then
	modifier_mount_ogreseal = class({})
end

--------------------------------------------------------------------------------

function modifier_mount_ogreseal:IsPermanent()
	return true
end

------------------------------------------------------------------------------

function modifier_mount_ogreseal:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_ogreseal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_ogreseal:GetTexture()
	return "mount_ogreseal"
end