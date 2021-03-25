
local PUDGE_BOT_STATE_IDLE 		= 0
local PUDGE_BOT_STATE_ATTACK 	= 1

-----------------------------------------------------------------------------------------------------

if CItemsScenarioPudgeBot == nil then
	CItemsScenarioPudgeBot = class({})
end

--------------------------------------------------------------------------------

function CItemsScenarioPudgeBot:constructor( me )
	self.me = me
	self.nBotState = PUDGE_BOT_STATE_IDLE
	self.bMovedToStart = false
	self.hAbilityHook = self.me:FindAbilityByName( "pudge_meat_hook" )
	self.hAttackTarget = nil
	self.nIdleCounter = 0
	self.nRetreatTime = 30
	self.hInitialMoveLoc = Entities:FindByName( nil, "enemy_location_1" )
	self.hRetreatMoveLoc = Entities:FindByName( nil, "enemy_retreat_location" )
	ScriptAssert( self.hRetreatMoveLoc ~= nil, "self.hRetreatMoveLoc is nil!" )

	printf( "PudgeBot::constructor" )
end

--------------------------------------------------------------------------------

function CItemsScenarioPudgeBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CItemsScenarioPudgeBot:BotThink()
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

	if self.nIdleCounter > self.nRetreatTime then
		self:Retreat()
		return 0.5
	end

	if self.nBotState == PUDGE_BOT_STATE_IDLE then
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( PUDGE_BOT_STATE_ATTACK )
			self:AttackTarget( self.hAttackTarget )
		else
			--print("No heroes found")
			self.nIdleCounter = self.nIdleCounter + 1
			if self.bMovedToStart == false then
				self:MoveToStart()
			end
		end
	else
		self:AttackTarget( self.hAttackTarget )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "PudgeThink", PudgeThink, 0.25 )

		thisEntity.Bot = CItemsScenarioPudgeBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function PudgeThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

function CItemsScenarioPudgeBot:AttackTarget( hTarget )
	if self.hAbilityHook and self.hAbilityHook:IsFullyCastable() then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hAbilityHook:entindex(),
			Position = hTarget:GetAbsOrigin(),
		} )
	else
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex(),
		} )
	end
end

--------------------------------------------------------------------------------

function CItemsScenarioPudgeBot:MoveToStart()
	self.bMovedToStart = true
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.hInitialMoveLoc:GetAbsOrigin(),
		Queue = true,
	} )
end

--------------------------------------------------------------------------------

function CItemsScenarioPudgeBot:Retreat()
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.hRetreatMoveLoc:GetAbsOrigin(),
		Queue = true,
	} )
end

--------------------------------------------------------------------------------
