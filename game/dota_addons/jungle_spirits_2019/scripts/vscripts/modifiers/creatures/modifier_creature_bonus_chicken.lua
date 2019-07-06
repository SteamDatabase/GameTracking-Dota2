modifier_creature_bonus_chicken = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnCreated( kv )
	self.total_gems = self:GetAbility():GetSpecialValueFor( "total_gems" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	if IsServer() then
		self.flAccumDamage = 0
		self.nGemsDropped = 0
		self.bTeleporting = false
		self.vCenter = Vector( 2183, -333, 320 )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter
			})

		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		self:StartIntervalThink( 3.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
	}

	return funcs
end

function modifier_creature_bonus_chicken:OnIntervalThink()
	if IsServer() then
		if not self.bTeleporting then
			ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter + RandomVector( 3500 )
			})
		end
		

		if GameRules:GetGameTime() > self.flExpireTime then
			self:TeleportOut()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTakeDamage( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if not hAttacker:IsRealHero() then
			return 0
		end

		if hUnit == self:GetParent() then		
			local flDamage = params.damage
			if flDamage <= 0 then
				return
			end
			self.flAccumDamage = self.flAccumDamage + flDamage
			if self.flAccumDamage >= 20 then
				CJungleSpirits:DropSpiritGems( hUnit, GEMS_PER_SMALL_ITEM, hAttacker )

				self.flAccumDamage = self.flAccumDamage - 100
				self.nGemsDropped = self.nGemsDropped + 1
				self.total_gems = self.total_gems - 1
				if self.total_gems <= 0 then
					self:TeleportOut()
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:TeleportOut()
	self:GetParent():ForceKill( false )
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 500 + ( self.nGemsDropped * 10 )
	end
	return 500
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
		
		if GameRules:GetGameTime() > self.flExpireTime or self.total_gems <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end