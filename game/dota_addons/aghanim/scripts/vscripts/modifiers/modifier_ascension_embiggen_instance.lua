
modifier_ascension_embiggen_instance = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_embiggen_instance:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_embiggen_instance:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_ascension_embiggen_instance:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------------------------

function modifier_ascension_embiggen_instance:OnRemoved( )
	if IsServer() == false then
		return
	end

	local hBuff = self:GetParent():FindModifierByName( "modifier_ascension_embiggen" )
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
