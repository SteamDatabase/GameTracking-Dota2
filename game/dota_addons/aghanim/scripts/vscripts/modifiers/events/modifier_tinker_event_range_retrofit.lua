
modifier_tinker_event_range_retrofit = class({})

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:IsPermanent()
	return true 
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:RemoveOnDeath()
	return false 
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:GetTexture()
	return "npc_dota_hero_tinker"
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end  

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:OnCreated( kv )
	if IsServer() == false then 
		return
	end

	self.nAttackRange = kv[ "attack_range" ]
	self.nCastRange = kv[ "cast_range" ]

	self:SetHasCustomTransmitterData( true )
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:GetModifierCastRangeBonusStacking( params )
	if bitand( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK ) ~= 0 then
		return self.nAttackRange
	end
	return self.nCastRange
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:GetModifierAttackRangeBonus( params )
	return self.nAttackRange
end

------------------------------------------------------------------ --------------

function modifier_tinker_event_range_retrofit:AddCustomTransmitterData( )
	return
	{
		attack_range = self.nAttackRange,
		cast_range = self.nCastRange
	}
end

--------------------------------------------------------------------------------

function modifier_tinker_event_range_retrofit:HandleCustomTransmitterData( data )
	self.nAttackRange = data.attack_range
	self.nCastRange = data.cast_range
end


