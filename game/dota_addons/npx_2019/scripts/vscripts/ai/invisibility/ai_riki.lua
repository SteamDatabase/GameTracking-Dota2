
local RIKI_BOT_STATE_INTRO					= 0
local RIKI_BOT_STATE_IDLE					= 1
local RIKI_BOT_STATE_ATTACK					= 2
local RIKI_BOT_STATE_SMOKE_SCREEN			= 3
local RIKI_BOT_STATE_BLINK_STRIKE			= 4

-----------------------------------------------------------------------------------------------------

if CInvisibilityRikiBot == nil then
	CInvisibilityRikiBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityRikiBot:constructor( me )
	self.me = me
	self.hAbilitySmokeScreen = self.me:FindAbilityByName( "riki_smoke_screen" )
	self.hAbilityBlinkStrike = self.me:FindAbilityByName( "riki_blink_strike" )
	self.nBotState = RIKI_BOT_STATE_INTRO
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityRikiBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityRikiBot:GoToAttack()

	local hAttackPosition = Entities:FindByName( nil, "riki_attack_pos" )
	if hAttackPosition ~= nil then

		if self.hAbilityBlinkStrike then
			self.hAbilityBlinkStrike:SetCurrentAbilityCharges( 1 )
		end

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = hAttackPosition:GetAbsOrigin(),
			Queue = false,
		} )

		self:ChangeBotState( RIKI_BOT_STATE_IDLE )
	end
	
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityRikiBot:BotThink()

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

	if self.nBotState == RIKI_BOT_STATE_INTRO then


	elseif self.nBotState == RIKI_BOT_STATE_IDLE then

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( RIKI_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == RIKI_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( RIKI_BOT_STATE_IDLE )
		end

		self:AttackTarget( self.hAttackTarget )

		--[[
		if self.hAbilitySmokeScreen and self.hAbilitySmokeScreen:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( RIKI_BOT_STATE_SMOKE_SCREEN )
			end
		end
		]]--

		--[[
		if self.hAbilityBlinkStrike and self.hAbilityBlinkStrike:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( RIKI_BOT_STATE_BLINK_STRIKE )
			end
		end
		]]--

	elseif self.nBotState == RIKI_BOT_STATE_SMOKE_SCREEN then

		local vPos = self.hAttackTarget:GetOrigin()
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hAbilitySmokeScreen:entindex(),
			Position = vPos,
		} )

		self:UseDiffusalBlade()
		
		self:ChangeBotState( RIKI_BOT_STATE_ATTACK )

	elseif self.nBotState == RIKI_BOT_STATE_BLINK_STRIKE then

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityBlinkStrike:entindex(),
			TargetIndex = self.hAttackTarget:entindex()
		} )

		self:ChangeBotState( RIKI_BOT_STATE_ATTACK )
	end
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityRikiBot:UseDiffusalBlade()
	if self.hAttackTarget ~= nil and self.hAttackTarget:IsAlive() == true and self.hAttackTarget:IsNull() == false then
		local hItemDiffusal = FindItemByName( self.me, "item_diffusal_blade" )
		if hItemDiffusal and hItemDiffusal:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hItemDiffusal:entindex(),
				TargetIndex = self.hAttackTarget:entindex()
			} )
		end
	end
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityRikiBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "RikiThink", RikiThink, 0.25 )
		thisEntity.Bot = CInvisibilityRikiBot( thisEntity )
	end
end

function RikiThink()
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
