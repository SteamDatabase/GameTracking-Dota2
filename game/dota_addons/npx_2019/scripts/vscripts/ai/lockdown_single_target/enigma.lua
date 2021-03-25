
local ENIGMA_BOT_STATE_IDLE = 0

--------------------------------------------------------------------------------

if CLockdownScenarioEnigmaBot == nil then
	CLockdownScenarioEnigmaBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaBot:constructor( me )
	self.me = me
	self.nBotState = ENIGMA_BOT_STATE_IDLE
	self.hBlackHoleAbility = self.me:FindAbilityByName( "enigma_black_hole" )	

	-- Why isn't the scenario doing all this?
	if self.me:GetAbilityPoints() > 0 then
		local hAbility = self.me:FindAbilityByName( "enigma_black_hole" )
		if hAbility ~= nil then
			self.me:UpgradeAbility( hAbility )
		else
			printf( "Failed to find ability %s to upgrade it", hAbility:GetAbilityName() )
		end
	end
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaBot:BotThink()
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

	if self.nBotState == ENIGMA_BOT_STATE_IDLE then
		local nBlackHoleCastRange = 275
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, nBlackHoleCastRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes > 0 then
			local vBlackHolePos = Heroes[ 1 ]:GetAbsOrigin()
			self.me:CastAbilityOnPosition( vBlackHolePos, self.hBlackHoleAbility, -1 )

			return 4.0
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioEnigmaThink", LockdownScenarioEnigmaThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioEnigmaBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioEnigmaThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------
