modifier_dig_site_cooldown = class({})

--------------------------------------------------------------------------------

function modifier_dig_site_cooldown:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dig_site_cooldown:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dig_site_cooldown:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetModel("models/props_generic/chest_treasure_02_open.vmdl")
		self:GetParent():StartGesture( ACT_DOTA_SPAWN)
	end
end

--------------------------------------------------------------------------------

function modifier_dig_site_cooldown:OnDestroy()
	if IsServer() then
		self:GetParent():SetModel("models/props_generic/chest_treasure_02.vmdl")
		self:GetParent():StartGesture( ACT_DOTA_IDLE)
	end
end

--------------------------------------------------------------------------------

function modifier_dig_site_cooldown:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end