
local URSA_BOT_STATE_IDLE					= 1
local URSA_BOT_STATE_ATTACK					= 2
local URSA_BOT_STATE_OVERPOWER				= 3
local URSA_BOT_STATE_BKB					= 4

-----------------------------------------------------------------------------------------------------

if CGlimmerCapeUrsaBot == nil then
	CGlimmerCapeUrsaBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeUrsaBot:constructor( me )
	self.me = me
	self.hAbilityOverpower = self.me:FindAbilityByName( "ursa_overpower" )
	self.nBotState = URSA_BOT_STATE_IDLE
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeUrsaBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeUrsaBot:BotThink()

	if not IsServer() then
		return
	end
	if self.bWasKilled then
		return -1
	end
	if ( not self.me:IsAlive() ) then
		self.bWasKilled = true
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if self.nBotState == URSA_BOT_STATE_IDLE then

		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( URSA_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == URSA_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( URSA_BOT_STATE_IDLE )
		end

		self:AttackTarget( self.hAttackTarget )
		if self.hAbilityOverpower and self.hAbilityOverpower:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( URSA_BOT_STATE_OVERPOWER )
			end
		end

	elseif self.nBotState == URSA_BOT_STATE_OVERPOWER then

		if self.hAbilityOverpower == nil then
			self:ChangeBotState( URSA_BOT_STATE_IDLE )
		end
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hAbilityOverpower:entindex(),
		} )
		
		if not self.hAbilityOverpower:IsFullyCastable() then
			self:ChangeBotState( URSA_BOT_STATE_ATTACK )
		end

	elseif self.nBotState == URSA_BOT_STATE_BKB then
		local hItemBKB = FindItemByName( self.me, "item_black_king_bar" )
		if hItemBKB and hItemBKB:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hItemBKB:entindex(),
			} )
		end

		self:ChangeBotState( URSA_BOT_STATE_ATTACK )
	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeUrsaBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "UrsaThink", UrsaThink, 0.25 )
		thisEntity.Bot = CGlimmerCapeUrsaBot( thisEntity )
	end
end

function UrsaThink()
	if IsServer() == false then
		return -1
	end

	local fThinkTime = thisEntity.Bot:BotThink()
	if fThinkTime then
		return fThinkTime
	end

	return 0.1
end

-----------------------------------------------------------------------------------------------------

function FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end
