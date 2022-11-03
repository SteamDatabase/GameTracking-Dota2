if modifier_diretide_home_bucket_heal == nil then
modifier_diretide_home_bucket_heal = class({})
end

------------------------------------------------------------------------------

function modifier_diretide_home_bucket_heal:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_diretide_home_bucket_heal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_diretide_home_bucket_heal:OnCreated( kv )
	if IsServer() == true then
		self:StartIntervalThink( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_diretide_home_bucket_heal:CheckState()
	if IsServer() == false then
		return
	end

	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

----------------------------------------------------------------------------------------

function modifier_diretide_home_bucket_heal:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetParent():GetHealth() < self:GetParent():GetMaxHealth() then
		self:GetParent():SetHealth( self:GetParent():GetMaxHealth() )
	end
end
