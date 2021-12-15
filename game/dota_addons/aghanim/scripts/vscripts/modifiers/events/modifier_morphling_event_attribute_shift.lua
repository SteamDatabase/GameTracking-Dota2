
modifier_morphling_event_attribute_shift = class({})

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:IsPermanent()
	return true 
end

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:RemoveOnDeath()
	return false 
end

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:GetTexture()
	return "npc_dota_hero_morphling"
end

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end  

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:OnCreated( kv )
	if IsServer() == false then 
		return
	end

	self.nGainAttribute = kv[ "gain_attribute" ]
	self.nLoseAttribute = kv[ "lose_attribute" ]
	self.nGainAttributeValue = kv[ "gain_attribute_value" ]
	self.nLoseAttributeValue = kv[ "lose_attribute_value" ]

	if self.nGainAttribute == 0 then 
		self:GetParent():SetBaseStrength( self:GetParent():GetBaseStrength() + self.nGainAttributeValue )
	end
	if self.nGainAttribute == 1 then 
		self:GetParent():SetBaseAgility( self:GetParent():GetBaseAgility() + self.nGainAttributeValue )
	end
	if self.nGainAttribute == 2 then 
		self:GetParent():SetBaseIntellect( self:GetParent():GetBaseIntellect() + self.nGainAttributeValue )
	end

	if self.nLoseAttribute == 0 then 
		self:GetParent():SetBaseStrength( math.max( 1, self:GetParent():GetBaseStrength() - self.nLoseAttributeValue ) )
	end
	if self.nLoseAttribute == 1 then 
		self:GetParent():SetBaseAgility( math.max( 1, self:GetParent():GetBaseAgility() - self.nLoseAttributeValue ) )
	end
	if self.nLoseAttribute == 2 then 
		self:GetParent():SetBaseIntellect( math.max( 1, self:GetParent():GetBaseIntellect() - self.nLoseAttributeValue ) )
	end
end

--------------------------------------------------------------------------------

function modifier_morphling_event_attribute_shift:OnDestroy()
	if IsServer() == false then 
		return
	end

	if self.nGainAttribute == 0 then 
		self:GetParent():SetBaseStrength( math.max( 1,self:GetParent():GetBaseStrength() - self.nGainAttributeValue ) )
	end
	if self.nGainAttribute == 1 then 
		self:GetParent():SetBaseAgility( math.max( 1,self:GetParent():GetBaseAgility() - self.nGainAttributeValue ) )
	end
	if self.nGainAttribute == 2 then 
		self:GetParent():SetBaseIntellect(math.max( 1,self:GetParent():GetBaseIntellect() - self.nGainAttributeValue ) )
	end

	if self.nLoseAttribute == 0 then 
		self:GetParent():SetBaseStrength( self:GetParent():GetBaseStrength() + self.nLoseAttributeValue )
	end
	if self.nLoseAttribute == 1 then 
		self:GetParent():SetBaseAgility( self:GetParent():GetBaseAgility() + self.nLoseAttributeValue ) 
	end
	if self.nLoseAttribute == 2 then 
		self:GetParent():SetBaseIntellect( self:GetParent():GetBaseIntellect() + self.nLoseAttributeValue )
	end
end
