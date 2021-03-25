
local SHAMAN_BOT_STATE_IDLE						= 0
local SHAMAN_BOT_STATE_RUNE						= 1
local SHAMAN_BOT_STATE_KILL_TARGET				= 2
local SHAMAN_BOT_STATE_RETREAT					= 3 -- unused

-----------------------------------------------------------------------------------------------------

if CBKBPAShadowShamanBot == nil then
	CBKBPAShadowShamanBot = class({})
end

function CBKBPAShadowShamanBot:constructor( me )
	self.me = me

	self.hAbilityVoodoo = self.me:FindAbilityByName( "shadow_shaman_voodoo" )
	ScriptAssert( self.hAbilityVoodoo ~= nil, "self.hAbilityVoodoo is nil!" )
	self.hAbilityShackles = self.me:FindAbilityByName( "shadow_shaman_shackles" )
	ScriptAssert( self.hAbilityShackles ~= nil, "self.hAbilityShackles is nil!" )

	self.hBountyRune = Entities:FindByClassname( nil, "dota_item_rune" )
	ScriptAssert( self.hBountyRune ~= nil, "self.hBountyRune is nil!" )
	self.vRuneLoc = self.hBountyRune:GetAbsOrigin()

	self.hEscapeLoc = Entities:FindByName( nil, "escape_location" )
	ScriptAssert( self.hEscapeLoc ~= nil, "self.hEscapeLoc is nil!" )


	self.nBotState = SHAMAN_BOT_STATE_IDLE
	self.hAttackTarget = nil
end

function CBKBPAShadowShamanBot:StartAI()
	if self.nBotState ~= SHAMAN_BOT_STATE_IDLE then
		return
	end

	self:ChangeBotState( SHAMAN_BOT_STATE_RUNE )
end


function CBKBPAShadowShamanBot:SetScriptedAttackTarget( hTarget )
	if self.hAttackTarget == hTarget then
		return
	end

	self.hAttackTarget = hTarget
	self:ChangeBotState( SHAMAN_BOT_STATE_KILL_TARGET )
	self.flStateStartTime = 0.0
end

function CBKBPAShadowShamanBot:StateName( nState )
	if nState == SHAMAN_BOT_STATE_IDLE then return "Idle"
	elseif nState == SHAMAN_BOT_STATE_RUNE then return "RUNE"
	elseif nState == SHAMAN_BOT_STATE_KILL_TARGET then return "KILL_TARGET"
	elseif nState == SHAMAN_BOT_STATE_RETREAT then return "RETREAT"
	else return "UNKNOWN" end
end

function CBKBPAShadowShamanBot:ChangeBotState( nNewState )
	print( "++++++++++Shaman changing from state " .. self:StateName( self.nBotState ) .. " to " .. self:StateName( nNewState ) )
	self.nBotState = nNewState
end

function CBKBPAShadowShamanBot:CheckAggro()
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
end

function CBKBPAShadowShamanBot:BotThink()
	--print( "...Shaman in state " .. self:StateName( self.nBotState ) )

	if self.nBotState == SHAMAN_BOT_STATE_IDLE then
		
		if self:CheckAggro() then return end
		
	elseif self.nBotState == SHAMAN_BOT_STATE_RUNE then
		
		if self:CheckAggro() then return end

		
		if self.hBountyRune ~= nil and self.hBountyRune:IsNull() == false then
			--printf( "Shaman is moving to %s at %s", tostring( self.hBountyRune ), self.hBountyRune:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
				TargetIndex = self.hBountyRune:entindex()
			} )
			return
		end
			
		self:MoveToLocation( self.vRuneLoc )

	elseif self.nBotState == SHAMAN_BOT_STATE_KILL_TARGET then

		if not self.hAttackTarget:IsAlive() then
			return
		end

		local flLockdownTimeLeft = 0
		local hHex = self.hAttackTarget:FindModifierByName( "modifier_shadow_shaman_voodoo" )
		if hHex ~= nil and hHex:IsNull() == false then
			flLockdownTimeLeft = hHex:GetRemainingTime()
		end
		local hShackles = self.hAttackTarget:FindModifierByName( "modifier_shadow_shaman_shackles" )
		if hShackles ~= nil and hShackles:IsNull() == false then
			flLockdownTimeLeft = math.max( hShackles:GetRemainingTime(), flLockdownTimeLeft )
		end

		
		if self.hAttackTarget:IsMagicImmune() == false then
			-- try to CC
			if self.hAbilityVoodoo and self.hAbilityVoodoo:IsFullyCastable() then
				if flLockdownTimeLeft < 0.1 then
					self:CastAbilityAtTarget( self.hAbilityVoodoo, self.hAttackTarget )
					return
				end
			elseif self.hAbilityShackles and self.hAbilityShackles:IsFullyCastable() then
				if flLockdownTimeLeft < 0.4 then
					self:CastAbilityAtTarget( self.hAbilityShackles, self.hAttackTarget )
					return
				end
			end
		end

		-- Are we channeling Shackles? Or otherwise casting? Bail.
		if self.me:GetCurrentActiveAbility() ~= nil then
			return
		end

		--[[print( "--------Shaman health Pct " .. ( self.me:GetHealth() / self.me:GetMaxHealth() ) )

		if self.me:GetHealth() < self.me:GetMaxHealth() * 0.3 then
			self:ChangeBotState( SHAMAN_BOT_STATE_RETREAT )
			return
		end--]]

		
		-- else just attack
		self:AttackTarget( self.hAttackTarget )

	elseif self.nBotState == SHAMAN_BOT_STATE_RETREAT then

		if self.me:GetHealth() > self.me:GetMaxHealth() * 0.75 then
			self:ChangeBotState( SHAMAN_BOT_STATE_KILL_TARGET )
			return
		end
		
		self:MoveToLocation( self.hEscapeLoc:GetAbsOrigin() )
	end
end

function CBKBPAShadowShamanBot:MoveToLocation( vPos )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = false,
	} )
end

function CBKBPAShadowShamanBot:CastAbilityAtTarget( hAbility, hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hAbility:entindex(),
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
end

function CBKBPAShadowShamanBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
end

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
		thisEntity:SetContextThink( "BKBPAShamanThink", BKBPAShamanThink, 0.25 )

		thisEntity.Bot = CBKBPAShadowShamanBot( thisEntity )
	end
end

function BKBPAShamanThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


