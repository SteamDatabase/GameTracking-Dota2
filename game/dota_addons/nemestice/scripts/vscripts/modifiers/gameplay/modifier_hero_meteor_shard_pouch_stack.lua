
if modifier_hero_meteor_shard_pouch_stack == nil then
	modifier_hero_meteor_shard_pouch_stack = class({})
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_stack:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_stack:IsPurgable()
	return false
end


--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_stack:OnCreated( kv )
	if IsServer() == false then
		return
	end
	--print(" **** added shard stack!")
	--self:GetAbility():SetCurrentAbilityCharges( self:GetAbility():GetCurrentAbilityCharges() + 1 )
	-- done by ability:AddShard() - self:GetAbility():UpdateStats()
end

--------------------------------------------------------------------------------

--[[function modifier_hero_meteor_shard_pouch_stack:OnRefresh( kv )
	if IsServer() == false then
		return
	end
	self:GetAbility():UpdateStats()
end--]]

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_stack:OnDestroy()
	if IsServer() == false then
		return
	end
	--print(" ----- lost shard stack!")
	--self:GetAbility():SetCurrentAbilityCharges( self:GetAbility():GetCurrentAbilityCharges() - 1 )
	if self.bDoNotNotifyOnDestroy == true then
		return
	end
	if self:GetParent() and self:GetParent():GetPlayerOwner() and self:GetParent():IsRealHero() then
		GameRules.Nemestice:ChangeMeteorEnergy( self:GetParent():GetPlayerOwnerID(), -1, "decay", nil, self:GetParent(), 0, true, 1 )
	end
	self:GetAbility():UpdateStats()
end

--------------------------------------------------------------------------------
