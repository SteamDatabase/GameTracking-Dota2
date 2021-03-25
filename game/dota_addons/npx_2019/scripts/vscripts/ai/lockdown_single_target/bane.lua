
local BANE_BOT_STATE_IDLE = 0
local BANE_BOT_STATE_AGGRO = 1
local BANE_BOT_STATE_REMOVAL = 2

--------------------------------------------------------------------------------

if CLockdownScenarioBaneBot == nil then
	CLockdownScenarioBaneBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioBaneBot:constructor( me )
	self.me = me
	self.nBotState = BANE_BOT_STATE_IDLE

	self.hBrainSapAbility = self.me:FindAbilityByName( "bane_brain_sap" )	
	self.hFiendsGripAbility = self.me:FindAbilityByName( "bane_fiends_grip" )

	self.hEscapeLoc = Entities:FindByName( nil, "escape_location" )
	ScriptAssert( self.hEscapeLoc ~= nil, "self.hEscapeLoc is nil!" )
end

--------------------------------------------------------------------------------

function CLockdownScenarioBaneBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioBaneBot:BotThink()
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

	if self.me:IsChanneling() then
		printf( "Bane is busy channeling, return to think shortly" )
		return 0.25
	end

	if self.nBotState == BANE_BOT_STATE_IDLE then
		local nSearchRange = 700
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes > 0 then
			self:ChangeBotState( BANE_BOT_STATE_AGGRO )
		end
	elseif self.nBotState == BANE_BOT_STATE_AGGRO then
		if GameRules.DotaNPX:IsTaskComplete( "protect_lina" ) then
			self.nBotState = BANE_BOT_STATE_REMOVAL

			return 1.0
		end

		local nSearchRange = 1000
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes > 0 then
			-- Find lowest health enemy
			local hLowestHealthEnemy = nil
			for _, hHero in pairs( Heroes ) do
				if hLowestHealthEnemy == nil or hHero:GetHealthPercent() < hLowestHealthEnemy:GetHealthPercent() then
					hLowestHealthEnemy = hHero
				end
			end

			if self.hFiendsGripAbility and self.hFiendsGripAbility:IsFullyCastable() then
				self.me:CastAbilityOnTarget( hLowestHealthEnemy, self.hFiendsGripAbility, -1 )

				return self.hFiendsGripAbility:GetCastPoint() + 0.3
			elseif self.hBrainSapAbility and self.hBrainSapAbility:IsFullyCastable() then
				self.me:CastAbilityOnTarget( hLowestHealthEnemy, self.hBrainSapAbility, -1 )

				return self.hBrainSapAbility:GetCastPoint() + 0.2
			end
		end
	elseif self.nBotState == BANE_BOT_STATE_REMOVAL then
		UTIL_Remove( self.me )

		return nil

		--[[
		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		})

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.hEscapeLoc:GetAbsOrigin(),
			Queue = true,
		} )
		]]
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioBaneThink", LockdownScenarioBaneThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioBaneBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioBaneThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------
