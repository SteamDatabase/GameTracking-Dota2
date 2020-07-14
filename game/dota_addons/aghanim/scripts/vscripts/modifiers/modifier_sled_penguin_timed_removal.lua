
modifier_sled_penguin_timed_removal = class({})

----------------------------------------------------------------------------------

function modifier_sled_penguin_timed_removal:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_timed_removal:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_timed_removal:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
	end
end

-----------------------------------------------------------------------
