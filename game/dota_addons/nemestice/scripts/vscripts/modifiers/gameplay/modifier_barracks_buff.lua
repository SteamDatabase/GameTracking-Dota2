if modifier_barracks_buff == nil then
modifier_barracks_buff = class({})
end

-----------------------------------------------------------------------------------------

function modifier_barracks_buff:constructor()
	self.nBonusArmor = 0
	self.nBonusDamage = 0
	self.flRegenPct = 0
	self.bRegen = true
end

------------------------------------------------------------------------------

function modifier_barracks_buff:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:OnCreated( kv )
	self:SetHasCustomTransmitterData( true )
	self:OnRefresh( kv )
	if IsServer() == true then
		self:StartIntervalThink( 0.1 )
		self.flLastAttackTime = -9999.0
	end
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:OnRefresh( kv )
	self.building_armor_bonus = kv.building_armor_bonus
	self.building_hp_buff_pct = kv.building_hp_buff_pct
	self.building_dmg_buff_pct = kv.building_dmg_buff_pct
	
	if IsServer() == true then
		self.nBonusArmor = self.building_armor_bonus
		self.nBonusDamage = ( ( ( self:GetParent():GetBaseDamageMin() + self:GetParent():GetBaseDamageMax() ) / 2 ) * self.building_dmg_buff_pct ) / 100
		self.flRegenPct = _G.NEMESTICE_TOWER_REGEN_PCT_PER_SEC
		--printf( "Bonus damage is %d", math.floor( self.nBonusDamage ) )
		self:SendBuffRefreshToClients()
	end
end

----------------------------------------------------------------------------------------

function modifier_barracks_buff:OnIntervalThink()
	if IsServer() == false then
		return
	end

	local bOldRegen = self.bRegen

	-- don't allow regen on towers if there are 4 or more standing
	local nNumTowers = GameRules.Nemestice:GetTowersControlledBy( self:GetParent():GetTeamNumber(), false )
	if nNumTowers >= _G.NEMESTICE_TOWER_REGEN_DISABLE_COUNT or self.flLastAttackTime + _G.NEMESTICE_TOWER_REGEN_PEACE_TIME > GameRules:GetDOTATime( false, true ) then
		self.bRegen = false
	else
		self.bRegen = true
	end
	if bOldRegen ~= self.bRegen then
		self:SendBuffRefreshToClients()
	end
end

----------------------------------------------------------------------------------------

function modifier_barracks_buff:CheckState()
	local state =
	{
		[MODIFIER_STATE_SPECIALLY_UNDENIABLE] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_IGNORING_STOP_ORDERS] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:AddCustomTransmitterData( )
	return
	{
		armor = self.nBonusArmor,
		damage = self.nBonusDamage,
		regenPct = self.flRegenPct,
		isRegen = ( self.bRegen and 1 ) or 0,
	}
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:HandleCustomTransmitterData( data )
	if data.armor ~= nil then
		self.nBonusArmor = tonumber( data.armor )
	end
	if data.damage ~= nil then
		self.nBonusDamage = tonumber( data.damage )
	end
	if data.regenPct ~= nil then
		self.flRegenPct = tonumber( data.regenPct )
	end
	if data.isRegen ~= nil then
		self.bRegen = tonumber( data.isRegen ) == 1
	end
end

-----------------------------------------------------------------------------------------

function modifier_barracks_buff:GetModifierExtraHealthPercentage( params )
	if self.building_hp_buff_pct == nil then return 0 end
	return self.building_hp_buff_pct
end

--------------------------------------------------------------------------------

function modifier_barracks_buff:GetModifierPreAttack_BonusDamage( params )
	--printf( "Return Bonus damage is %d", math.floor( self.nBonusDamage ) )
	return self.nBonusDamage
end

-----------------------------------------------------------------------------------------

function modifier_barracks_buff:GetModifierPhysicalArmorBonus( params )
	return self.nBonusArmor
end

-----------------------------------------------------------------------------------------

function modifier_barracks_buff:OnTakeDamage( params )
	if IsServer() == false then
		return
	end

	if params.unit == self:GetParent() then
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsNull() or hAttacker == self:GetParent() then
			return
		end
		self.flLastAttackTime = GameRules:GetDOTATime( false, true )
	end
end

-----------------------------------------------------------------------------------------

function modifier_barracks_buff:GetModifierHealthRegenPercentage( params )
	if self.bRegen == false then return 0 end
	return self.flRegenPct
end