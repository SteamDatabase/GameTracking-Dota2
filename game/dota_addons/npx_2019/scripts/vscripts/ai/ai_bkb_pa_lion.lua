
local AGGRO_DIST						= 1000
local BOT_STATE_IDLE					= 0
local BOT_STATE_RUNE					= 1
local BOT_STATE_KILL_TARGET				= 2
local BOT_STATE_RETREAT					= 3 -- unused

-----------------------------------------------------------------------------------------------------

if CBKBPALionBot == nil then
	CBKBPALionBot = class({})
end

function CBKBPALionBot:constructor( me )
	self.me = me

	self.hAbilityHex = self.me:FindAbilityByName( "lion_voodoo" )
	self.hAbilityImpale = self.me:FindAbilityByName( "lion_impale" )
	self.hAbilityFinger = self.me:FindAbilityByName( "lion_finger_of_death" )

	self.hBountyRune = Entities:FindByClassname( nil, "dota_item_rune" )
	ScriptAssert( self.hBountyRune ~= nil, "self.hBountyRune is nil!" )
	self.vRuneLoc = self.hBountyRune:GetAbsOrigin()

	self.hEscapeLoc = Entities:FindByName( nil, "escape_location" )
	ScriptAssert( self.hEscapeLoc ~= nil, "self.hEscapeLoc is nil!" )


	self.nBotState = BOT_STATE_IDLE
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:StartAI()
	if self.nBotState ~= BOT_STATE_IDLE then
		return
	end

	self:ChangeBotState( BOT_STATE_RUNE )
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:SetScriptedAttackTarget( hTarget )
	if self.hAttackTarget == hTarget then
		return
	end

	self.hAttackTarget = hTarget
	self:ChangeBotState( BOT_STATE_KILL_TARGET )
	self.flStateStartTime = 0.0
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:StateName( nState )
	if nState == BOT_STATE_IDLE then return "Idle"
	elseif nState == BOT_STATE_RUNE then return "RUNE"
	elseif nState == BOT_STATE_KILL_TARGET then return "KILL_TARGET"
	elseif nState == BOT_STATE_RETREAT then return "RETREAT"
	else return "UNKNOWN" end
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:ChangeBotState( nNewState )
	--print( "++++++++++" .. self.me:GetUnitName() .. " changing from state " .. self:StateName( self.nBotState ) .. " to " .. self:StateName( nNewState ) )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:CheckAggro()
	-- check if enemy is close, switch state
	-- (this means you can't avoid the starting waypoint)

	local nDist = AGGRO_DIST
	if self.hBountyRune == nil or self.hBountyRune:IsNull() == true then
		nDist = 10000
	end

	local hEnemies = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), nil, nDist, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies > 0 then
		self:SetScriptedAttackTarget( hEnemies[1] )
		return true
	end
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:BotThink()
	--print( "...Shaman in state " .. self:StateName( self.nBotState ) )

	if self.nBotState == BOT_STATE_IDLE then
		
		if self:CheckAggro() then return end
		
	elseif self.nBotState == BOT_STATE_RUNE then
		
		if self:CheckAggro() then return end

		
		if self.hBountyRune ~= nil and self.hBountyRune:IsNull() == false then
			--printf( "%s is moving to %s at %s", self.me:GetUnitName(), tostring( self.hBountyRune ), self.hBountyRune:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
				TargetIndex = self.hBountyRune:entindex()
			} )
			return
		end
			
		self:MoveToLocation( self.vRuneLoc )

	elseif self.nBotState == BOT_STATE_KILL_TARGET then

		-- bail if target is gone
		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then
			return
		end

		-- bail if we're currently casting.
		if self.me:GetCurrentActiveAbility() ~= nil then
			return
		end
		
		if self.hAttackTarget:IsMagicImmune() == false then
			if self.hAbilityHex and self.hAbilityHex:IsFullyCastable() then
				--print(" ** HEX" )
				self:CastAbilityAtTarget( self.hAbilityHex, self.hAttackTarget )
				return
			end

			if self.hAbilityFinger and self.hAbilityFinger:IsFullyCastable() then
				--print(" ** FINGER" )
				self:CastAbilityAtTarget( self.hAbilityFinger, self.hAttackTarget )
				return
			end
		end

		if self.hAbilityImpale and self.hAbilityImpale:IsFullyCastable() then
			--print(" ** IMPALE" )
			self:CastAbilityAtPosition( self.hAbilityImpale, self.hAttackTarget:GetAbsOrigin() )
			return
		end


		--[[print( "--------" .. self.me:GetUnitName() .. " health Pct " .. ( self.me:GetHealth() / self.me:GetMaxHealth() ) )

		if self.me:GetHealth() < self.me:GetMaxHealth() * 0.3 then
			self:ChangeBotState( BOT_STATE_RETREAT )
			return
		end--]]

		
		-- else just attack
		self:AttackTarget( self.hAttackTarget )

	elseif self.nBotState == BOT_STATE_RETREAT then

		if self.me:GetHealth() > self.me:GetMaxHealth() * 0.75 then
			self:ChangeBotState( BOT_STATE_KILL_TARGET )
			return
		end
		
		self:MoveToLocation( self.hEscapeLoc:GetAbsOrigin() )
	end
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:MoveToLocation( vPos )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = false,
	} )
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:CastAbilityAtTarget( hAbility, hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hAbility:entindex(),
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:CastAbilityAtPosition( hAbility, vPosition )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hAbility:entindex(),
		Position = vPosition,
		Queue = false,
	} )
end

-----------------------------------------------------------------------------------------------------

function CBKBPALionBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
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

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "BKBPALionThink", BKBPALionThink, 0.25 )

		thisEntity.Bot = CBKBPALionBot( thisEntity )
	end
end

function BKBPALionThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


