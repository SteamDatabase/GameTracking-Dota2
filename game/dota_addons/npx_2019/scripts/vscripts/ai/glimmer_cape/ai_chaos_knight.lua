
local CHAOS_KNIGHT_BOT_STATE_INTRO					= 0
local CHAOS_KNIGHT_BOT_STATE_IDLE					= 1
local CHAOS_KNIGHT_BOT_STATE_ATTACK					= 2
local CHAOS_KNIGHT_BOT_STATE_CHAOS_BOLT				= 3
local CHAOS_KNIGHT_BOT_STATE_BKB					= 4
local CHAOS_KNIGHT_BOT_STATE_TP_OUT					= 5

-----------------------------------------------------------------------------------------------------

if CGlimmerCapeChaosKnightBot == nil then
	CGlimmerCapeChaosKnightBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:constructor( me )
	self.me = me
	self.hAbilityChaosBolt = self.me:FindAbilityByName( "chaos_knight_chaos_bolt" )
	self.nBotState = CHAOS_KNIGHT_BOT_STATE_INTRO
	self.hAttackTarget = nil
	self.szMode = "attack_cm"

	self.hTpPosition = Entities:FindByName( nil, "chaos_knight_tp_pos" )
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:SetMode( szMode )
	print( 'CGlimmerCapeChaosKnightBot:SetMode to ' .. szMode )
	self.szMode = szMode
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:TpOut()
	self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_TP_OUT )
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:BotThink()

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

	if self.hTpScroll == nil then
		self.hTpScroll = self.me:GetItemInSlot( DOTA_ITEM_TP_SCROLL )
		if self.hTpScroll then
			self.hTpScroll:EndCooldown()
		end
	end

	print( 'CK think - state is ' .. tonumber( self.nBotState ) )

	if self.nBotState == CHAOS_KNIGHT_BOT_STATE_INTRO then

		local hAttackPosition
		if szMode == "attack_ogre" then
			print( 'attack_ogre is set! attacking position 2.' )
			hAttackPosition = Entities:FindByName( nil, "chaos_knight_attack_pos_2" )
		else
			hAttackPosition = Entities:FindByName( nil, "chaos_knight_attack_pos" )
		end
		if hAttackPosition ~= nil then

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = hAttackPosition:GetAbsOrigin(),
				Queue = false,
			} )

			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )
		end
	
	elseif self.nBotState == CHAOS_KNIGHT_BOT_STATE_IDLE then
		local hHero = self:FindSpecificTarget()
		if hHero ~= nil then
			self.hAttackTarget = hHero
			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_ATTACK )
		end

	elseif self.nBotState == CHAOS_KNIGHT_BOT_STATE_ATTACK then

		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then
			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )
		end

		local hItemPhaseBoots = FindItemByName( self.me, "item_phase_boots" )
		if hItemPhaseBoots == nil then
			print( 'ERROR - CK missing his phase boots' )
		end

		if hItemPhaseBoots and hItemPhaseBoots:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hItemPhaseBoots:entindex(),
			} )
		end

		self:AttackTarget( self.hAttackTarget )
		print( 'ATTACKING TARGET! ' .. self.hAttackTarget:GetUnitName() )

		local hHero = self:FindSpecificTarget()
		if hHero == nil then
			self.hAttackTarget = nil
			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )

		else
			self.hAttackTarget = hHero

			if self.hAbilityChaosBolt and self.hAbilityChaosBolt:IsFullyCastable() then
				self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_CHAOS_BOLT )
			end
		end

	elseif self.nBotState == CHAOS_KNIGHT_BOT_STATE_CHAOS_BOLT then
		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then
			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )
		end

		if self.hAbilityChaosBolt == nil then
			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )
		end
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityChaosBolt:entindex(),
			TargetIndex = self.hAttackTarget:entindex(),
		} )
		
		if not self.hAbilityChaosBolt:IsFullyCastable() then
			self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_ATTACK )
		end

	elseif self.nBotState == CHAOS_KNIGHT_BOT_STATE_BKB then
		local hItemBKB = FindItemByName( self.me, "item_black_king_bar" )
		if hItemBKB and hItemBKB:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hItemBKB:entindex(),
			} )
		end

		self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_ATTACK )

	elseif self.nBotState == CHAOS_KNIGHT_BOT_STATE_TP_OUT then
		if self.hTpScroll then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hTpScroll:entindex(),
				Position = self.hTpPosition:GetAbsOrigin(),
			} )
			
			if self.hTpScroll and not self.hTpScroll:IsFullyCastable() and not self.hTpScroll:IsChanneling() then
				self.me:ForceKill( false )
				--self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )
			end
		end

	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:FindSpecificTarget()
	local szPrioritizedHeroName
	if self.szMode == "attack_cm" then
		szPrioritizedHeroName = "npc_dota_hero_crystal_maiden"
	else
		szPrioritizedHeroName = "npc_dota_hero_ogre_magi"
	end

	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		print( 'CK BOT - found ' .. #Heroes )
		-- prioritize the proper hero
		for _,hHero in pairs( Heroes ) do
			print( 'HERO NAME = ' .. hHero:GetUnitName() .. ' prioritized hero name is ' .. szPrioritizedHeroName )
			if hHero:GetUnitName() == szPrioritizedHeroName then
				print( 'FOUND PRIORITIZED HERO ' .. szPrioritizedHeroName )
				return hHero
			end
		end
	end

	return nil
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:FindBestTarget()
	local szPrioritizedHeroName
	if szMode == "attack_cm" then
		szPrioritizedHeroName = "npc_dota_hero_crystal_maiden"
	else
		szPrioritizedHeroName = "npc_dota_hero_ogre_magi"
	end

	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize the proper hero
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == szPrioritizedHeroName then
				print( 'FOUND PRIORITIZED HERO ' .. szPrioritizedHeroName )
				return hHero
			end
		end

		-- attack first target in the list as a fallback
		--print( 'PRIORITIZED HERO ' .. szPrioritizedHeroName .. ' NOT FOUND - ATTACKING ' .. Heroes[1]:GetUnitName() )
		return Heroes[1]
	end

	return nil
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeChaosKnightBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "ChaosKnightThink", ChaosKnightThink, 0.25 )
		thisEntity.Bot = CGlimmerCapeChaosKnightBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function ChaosKnightThink()
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
