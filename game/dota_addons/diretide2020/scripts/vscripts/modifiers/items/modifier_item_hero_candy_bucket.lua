
if modifier_item_hero_candy_bucket == nil then
	modifier_item_hero_candy_bucket = class({})
end

function modifier_item_hero_candy_bucket:Init() 
	if self.bInited then
		return true
	end
	if self:GetAbility() == nil then
		return false
	end
	self.bInited = true
	self.max_hp_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "max_hp_penalty_per_charge" )
	self.model_scale_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_per_charge" )
	self.model_scale_penalty_max = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_max" )
	self.nPrevChargeCount = self:GetAbility():GetCurrentCharges()
	return true
end

------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:IsHidden() 
	if not self:Init() then return true end

	local bHidden = ( self:GetAbility():GetCurrentCharges() <= 0 )
	return bHidden
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:GetTexture()
	return "candy_carry_debuff"
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:OnCreated( kv )
	self:Init()
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:OnDeath( params )
	if not self:Init() then return 0 end

	if IsServer() then
		if params.unit == self:GetCaster() and params.unit:IsReincarnating() == false then
			self:DropCandy( params.attacker )
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:GetModifierExtraHealthPercentage( params )
	if not self:Init() then return 0 end

	local nReduction = ( -self.max_hp_penalty_per_charge * self:GetAbility():GetCurrentCharges() )
	if nReduction < -90 then
		nReduction = -90
	end
	--printf( "self.max_hp_penalty_per_charge: %d, current charges: %d, nReduction: %d", self.max_hp_penalty_per_charge, self:GetAbility():GetCurrentCharges(), nReduction )

	return nReduction
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:DropCandy( hAttacker )
	local hBucket = self:GetAbility()
	if hBucket == nil or self:GetParent() == nil or self:GetParent():IsRealHero() == false then
		return
	end

	local nNumCandy = hBucket:GetCurrentCharges()
	local nNumBigBags = math.floor( nNumCandy / _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG )
	if nNumBigBags > 0 then
		nNumCandy = nNumCandy - nNumBigBags * _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG
		for i = 1, nNumBigBags do
			GameRules.Diretide:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, true, 1.0 )
		end
	end
	for i = 1, nNumCandy do
		GameRules.Diretide:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, false, 1.0 )
	end

	hBucket:SetCurrentCharges( 0 )
end

--------------------------------------------------------------------------------

function modifier_item_hero_candy_bucket:GetModifierModelScale( params )
	if not self:Init() then return 0 end

	local fReduction = ( self.model_scale_penalty_per_charge * self:GetAbility():GetCurrentCharges() )
	if fReduction < self.model_scale_penalty_max then
		fReduction = self.model_scale_penalty_max
	end
	return fReduction
end
