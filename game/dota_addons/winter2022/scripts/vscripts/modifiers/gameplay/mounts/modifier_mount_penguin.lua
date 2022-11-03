if modifier_mount_penguin == nil then
	modifier_mount_penguin = class({})
end

--------------------------------------------------------------------------------

function modifier_mount_penguin:IsPermanent()
	return true
end

------------------------------------------------------------------------------

function modifier_mount_penguin:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_penguin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_penguin:GetTexture()
	return "mount_penguin"
end