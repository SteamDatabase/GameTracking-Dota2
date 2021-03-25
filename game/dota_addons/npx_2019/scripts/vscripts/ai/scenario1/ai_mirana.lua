
local MIRANA_BOT_STATE_IDLE						= 0
local MIRANA_BOT_STATE_ATTACK					= 1
local MIRANA_BOT_STATE_ARROW					= 2

-----------------------------------------------------------------------------------------------------

if CFirstScenarioMiranaBot == nil then
	CFirstScenarioMiranaBot = class({})
end

function CFirstScenarioMiranaBot:constructor( me )
	self.me = me
	self.hAbilityArrow = self.me:FindAbilityByName( "mirana_arrow" )	
	self.nBotState = MIRANA_BOT_STATE_IDLE
	self.hAttackTarget = nil
end



function CFirstScenarioMiranaBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CFirstScenarioMiranaBot:BotThink()

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

	if self.nBotState == MIRANA_BOT_STATE_IDLE then
	
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( MIRANA_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == MIRANA_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( MIRANA_BOT_STATE_IDLE )
		end
		
		self:AttackTarget( self.hAttackTarget )			
		self.hAbilityArrow:EndCooldown()
		if self.hAbilityArrow and self.hAbilityArrow:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( MIRANA_BOT_STATE_ARROW )
			end
		end

	elseif self.nBotState == MIRANA_BOT_STATE_ARROW then
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hAbilityArrow:entindex(),
			Position = self.hAttackTarget:GetAbsOrigin(),

		} )
		
		if self.hAbilityArrow and not self.hAbilityArrow:IsFullyCastable() then
			self:ChangeBotState( MIRANA_BOT_STATE_ATTACK )
		end
	end
end

function CFirstScenarioMiranaBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "FirstScenarioMiranaThink", FirstScenarioMiranaThink, 0.25 )

		thisEntity.Bot = CFirstScenarioMiranaBot( thisEntity )
		

	end
end

function FirstScenarioMiranaThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


