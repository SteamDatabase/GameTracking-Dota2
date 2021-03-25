
local DROW_RANGER_BOT_STATE_IDLE		= 0
local DROW_RANGER_BOT_STATE_RUNE		= 1
local DROW_RANGER_BOT_STATE_KILL_TARGET	= 2

-----------------------------------------------------------------------------------------------------

if CBKBPADrowRangerBot == nil then
	CBKBPADrowRangerBot = class({})
end

--------------------------------------------------------------------------------

function CBKBPADrowRangerBot:constructor( me )
	self.me = me
	self.nBotState = DROW_RANGER_BOT_STATE_IDLE
	self.hAttackTarget = nil

	self.hBountyRune = Entities:FindByClassname( nil, "dota_item_rune" )
	ScriptAssert( self.hBountyRune ~= nil, "self.hBountyRune is nil!" )
	self.vRuneLoc = self.hBountyRune:GetAbsOrigin()

	printf( "DrowRangerBot::constructor" )
end

function CBKBPADrowRangerBot:StartAI()
	if self.nBotState ~= DROW_RANGER_BOT_STATE_IDLE then
		return
	end

	self:ChangeBotState( DROW_RANGER_BOT_STATE_RUNE )
end

function CBKBPADrowRangerBot:SetScriptedAttackTarget( hTarget )
	if self.hAttackTarget == hTarget then
		return
	end

	self.hAttackTarget = hTarget
	self:ChangeBotState( DROW_RANGER_BOT_STATE_KILL_TARGET )
	self.flStateStartTime = 0.0
end
--------------------------------------------------------------------------------

function CBKBPADrowRangerBot:ChangeBotState( nNewState )
	print( "++++++++++Drow changing from state " .. self:StateName( self.nBotState ) .. " to " .. self:StateName( nNewState ) )
	self.nBotState = nNewState
end

function CBKBPADrowRangerBot:StateName( nState )
	if nState == DROW_RANGER_BOT_STATE_IDLE then return "Idle"
	elseif nState == DROW_RANGER_BOT_STATE_RUNE then return "RUNE"
	elseif nState == DROW_RANGER_BOT_STATE_KILL_TARGET then return "KILL_TARGET"
	else return "UNKNOWN" end
end

function CBKBPADrowRangerBot:CheckAggro()
	-- check if enemy is close, switch state
	-- (this means you can't avoid the starting waypoint)

	local nDist = 700
	if self.hBountyRune == nil or self.hBountyRune:IsNull() == true then
		nDist = 10000
	end

	local hEnemies = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), nil, nDist, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies > 0 then
		self:SetScriptedAttackTarget( hEnemies[1] )
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CBKBPADrowRangerBot:BotThink()
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

	if self.nBotState == DROW_RANGER_BOT_STATE_IDLE then
		
		if self:CheckAggro() then return end

	elseif self.nBotState == DROW_RANGER_BOT_STATE_RUNE then
		
		if self:CheckAggro() then return end

		self:MoveToLocation( self.vRuneLoc )

	elseif self.nBotState == DROW_RANGER_BOT_STATE_KILL_TARGET then
		self:AttackTarget( self.hAttackTarget )

		return 0.5
	end
end

function CBKBPADrowRangerBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
end

function CBKBPADrowRangerBot:MoveToLocation( vPos )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = false,
	} )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioDrowRangerThink", LockdownScenarioDrowRangerThink, 0.25 )

		thisEntity.Bot = CBKBPADrowRangerBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioDrowRangerThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5 -- if this is too fast it can short-circuit ability cast points
end

--------------------------------------------------------------------------------
