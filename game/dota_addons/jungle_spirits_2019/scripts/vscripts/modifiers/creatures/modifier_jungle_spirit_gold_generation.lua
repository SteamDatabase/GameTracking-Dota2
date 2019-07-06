modifier_jungle_spirit_gold_generation = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_gold_generation:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_gold_generation:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_gold_generation:OnCreated( kv )

	if IsServer() then
		
		self.nGoldMax = self:GetAbility():GetLevelSpecialValueFor( "gold_max", 1 )
		self.nGoldMin = self:GetAbility():GetLevelSpecialValueFor( "gold_min", 1 )
		self.fMinTime = self:GetAbility():GetLevelSpecialValueFor( "min_time", 1 )
		self.fMaxTime = self:GetAbility():GetLevelSpecialValueFor( "max_time", 1 )
		self.fDropInterval = self:GetAbility():GetLevelSpecialValueFor( "drop_interval", 1 )
		self.fVariance = self:GetAbility():GetLevelSpecialValueFor( "variance", 1 )
		self:StartIntervalThink( self.fDropInterval )

	end
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_gold_generation:OnIntervalThink()
	if IsServer() then
		if CJungleSpirits:IsSpiritActive( self:GetParent() ) ~= true then
			return 1
		end
		if self:GetParent():IsAlive() ~= true then
			return 1
		end

		local flNow = GameRules:GetGameTime()
		local nGoldToDrop = RemapVal( flNow, self.fMinTime, self.fMaxTime, self.nGoldMin, self.nGoldMax )
		nGoldToDrop = nGoldToDrop + nGoldToDrop*RandomFloat( -self.fVariance, self.fVariance )

		CJungleSpirits:DropGoldBag( self:GetParent():GetAbsOrigin(), nGoldToDrop )
	end
end

--------------------------------------------------------------------------------