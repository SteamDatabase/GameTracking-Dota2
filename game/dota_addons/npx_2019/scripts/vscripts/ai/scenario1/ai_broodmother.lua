
local BROODMOTHER_BOT_STATE_IDLE							= 0
local BROODMOTHER_BOT_STATE_ATTACK						= 1
local nTimer = 0
-----------------------------------------------------------------------------------------------------

if CFirstScenarioBroodmotherBot == nil then
	CFirstScenarioBroodmotherBot = class({})
end

function CFirstScenarioBroodmotherBot:constructor( me )
	self.me = me
	self.nBotState = BROODMOTHER_BOT_STATE_IDLE
	self.hAttackTarget = nil
	self.nTimer = 0
	self.bWasKilled = false
end



function CFirstScenarioBroodmotherBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CFirstScenarioBroodmotherBot:BotThink()
	
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

	if self.nBotState == BROODMOTHER_BOT_STATE_IDLE then
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( BROODMOTHER_BOT_STATE_ATTACK )
		end		
	elseif self.nBotState == BROODMOTHER_BOT_STATE_ATTACK then
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( BROODMOTHER_BOT_STATE_IDLE )
		end
		if self.nTimer == 10 then	
			FireGameEvent("spawn_spiderling", {})
			self.nTimer = 0
		end
		self.nTimer = self.nTimer + 1
		self:AttackTarget( self.hAttackTarget )			
	end
end

function CFirstScenarioBroodmotherBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "FirstScenarioBroodmotherThink", FirstScenarioBroodmotherThink, 0.25 )

		thisEntity.Bot = CFirstScenarioBroodmotherBot( thisEntity )
		

	end
end

function FirstScenarioBroodmotherThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()
	
	return 0.1
end

