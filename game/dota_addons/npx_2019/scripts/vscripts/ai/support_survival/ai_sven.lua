
local SVEN_BOT_STATE_IDLE					= 0
local SVEN_BOT_STATE_ATTACK					= 1
local SVEN_BOT_STATE_STORM_BOLT				= 2
local SVEN_BOT_STATE_BKB					= 3

-----------------------------------------------------------------------------------------------------

if CSupportSurvivalSvenBot == nil then
	CSupportSurvivalSvenBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CSupportSurvivalSvenBot:constructor( me )
	self.me = me
	self.hAbilityStormBolt = self.me:FindAbilityByName( "sven_storm_bolt" )
	self.nBotState = SVEN_BOT_STATE_IDLE
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CSupportSurvivalSvenBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CSupportSurvivalSvenBot:BotThink()

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

	if self.nBotState == SVEN_BOT_STATE_IDLE then

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( SVEN_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == SVEN_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( SVEN_BOT_STATE_IDLE )
		end

		-- pop bkb once we eat a frostbite
		local hFrostbiteModifier = self.me:FindModifierByName( "modifier_crystal_maiden_frostbite" )
		if hFrostbiteModifier then
			local hItemBKB = FindItemByName( self.me, "item_black_king_bar" )
			if hItemBKB and hItemBKB:IsFullyCastable() then
				self:ChangeBotState( SVEN_BOT_STATE_BKB )
				return 0.75
			end
		end
		
		self:AttackTarget( self.hAttackTarget )
		--self.hAbilityStormBolt:EndCooldown()
		if self.hAbilityStormBolt and self.hAbilityStormBolt:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( SVEN_BOT_STATE_STORM_BOLT )
			end
		end

	elseif self.nBotState == SVEN_BOT_STATE_STORM_BOLT then
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityStormBolt:entindex(),
			TargetIndex = self.hAttackTarget:entindex(),
		} )
		
		if self.hAbilityStormBolt and not self.hAbilityStormBolt:IsFullyCastable() then
			self:ChangeBotState( SVEN_BOT_STATE_ATTACK )
		end

	elseif self.nBotState == SVEN_BOT_STATE_BKB then
		local hItemBKB = FindItemByName( self.me, "item_black_king_bar" )
		if hItemBKB and hItemBKB:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hItemBKB:entindex(),
			} )
		end

		self:ChangeBotState( SVEN_BOT_STATE_ATTACK )
	end
end

-----------------------------------------------------------------------------------------------------

function CSupportSurvivalSvenBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "SvenThink", SvenThink, 0.25 )
		thisEntity.Bot = CSupportSurvivalSvenBot( thisEntity )
	end
end

function SvenThink()
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
