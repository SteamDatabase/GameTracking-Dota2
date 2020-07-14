
modifier_ascension_armor_sapping_instance = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_armor_sapping_instance:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_armor_sapping_instance:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_ascension_armor_sapping_instance:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_ascension_armor_sapping_instance:OnRemoved( )

	if IsServer() == false then
		return
	end

	local hBuff = self:GetParent():FindModifierByName( "modifier_ascension_armor_sapping" )
	if hBuff == nil then
		return
	end

 	local nNewStackCount = hBuff:GetStackCount() - 1
	if nNewStackCount > 0 then
		hBuff:SetStackCount( nNewStackCount )
	else
		hBuff:Destroy()
	end

end
