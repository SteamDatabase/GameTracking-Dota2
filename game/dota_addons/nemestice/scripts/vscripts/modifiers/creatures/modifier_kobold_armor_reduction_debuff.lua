if modifier_kobold_armor_reduction_debuff == nil then
	modifier_kobold_armor_reduction_debuff = class({})
end

-----------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:constructor()
	self.fArmorReduction = 0
end

------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:IsDebuff()
	return true
end

----------------------------------------

function modifier_kobold_armor_reduction_debuff:OnCreated( kv )
	self:SetHasCustomTransmitterData( true )
	self:OnRefresh( kv )
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:OnDestroy()
	if IsServer() == true then
		local hCounter = self:GetParent():FindModifierByName( "modifier_kobold_armor_reduction_counter" )
		if hCounter ~= nil then
			hCounter:DecrementStackCount()
		end		
	end
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:OnRefresh( kv )
	self.armor_reduction = kv.armor_reduction

	if IsServer() == true then
		self.fArmorReduction = -self.armor_reduction
		--printf( "^^^SERVER - REDUCTION PER STACK IS %f, STACK COUNT IS %d, ARMOR REDUCTION IS %f", self.armor_reduction, self:GetStackCount(), self.fArmorReduction )
		self:SendBuffRefreshToClients()
	end
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:AddCustomTransmitterData( )
	return
	{
		armor = self.fArmorReduction,
	}
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:HandleCustomTransmitterData( data )
	if data.armor ~= nil then
		self.fArmorReduction = tonumber( data.armor )
	end
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_debuff:GetModifierPhysicalArmorBonus( params )
	return self.fArmorReduction
end
