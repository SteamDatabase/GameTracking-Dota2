
local TROLL_BOT_STATE_IDLE					= 0
local TROLL_BOT_STATE_ATTACK				= 1
local TROLL_BOT_STATE_INACTIVE				= 2


-----------------------------------------------------------------------------------------------------

if CStatusEffectsTrollBot == nil then
	CStatusEffectsTrollBot = class({})
end

function CStatusEffectsTrollBot:constructor( me )
	self.me = me

	self.hAbilityFervor = self.me:FindAbilityByName( "troll_warlord_fervor" )
	self.hAbilityRage = self.me:FindAbilityByName( "troll_warlord_berserkers_rage" )
	self.hAbilityFervor:SetLevel(4)
	self.hAbilityRage:SetLevel(4)
	self.nBotState = TROLL_BOT_STATE_IDLE
	self.bIsActivated = false
	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})

end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsTrollBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_storm_spirit" then
				self.hAttackTarget = hHero
				return
			end
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------

function CStatusEffectsTrollBot:BotThink()

	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.nBotState == TROLL_BOT_STATE_INACTIVE then
		return -1
	end


	if self.me:FindModifierByName("modifier_heavens_halberd_debuff") ~= nil then
		self.me:RemoveModifierByName("modifier_fountain_aura_buff")

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP,
		} )

		self.nBotState =  TROLL_BOT_STATE_INACTIVE
		return -1
	end


	if self.nBotState == TROLL_BOT_STATE_IDLE then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE,
			AbilityIndex = self.hAbilityRage:entindex(),
		} )
		self.nBotState =  TROLL_BOT_STATE_ATTACK 
	elseif self.nBotState == TROLL_BOT_STATE_ATTACK then 

		if self.hAttackTarget == nil then
			self:FindBestTarget()
		end

  		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex()
			} )
			return
	end
	return 1
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		local hTask = GameRules.DotaNPX:GetTask( "disarm_enemy_hero" )
		if hTask ~= nil and hTask:IsCompleted() == true then
			return -1
		end

		thisEntity:SetContextThink( "CStatusEffectsTrollBotThink", CStatusEffectsTrollBotThink, 1 )
		thisEntity.Bot = CStatusEffectsTrollBot( thisEntity )
	end
end

function CStatusEffectsTrollBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 1
end


