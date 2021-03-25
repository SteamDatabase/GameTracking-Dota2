
local MAGNATAUR_BOT_STATE_IDLE					= 0
local MAGNATAUR_BOT_STATE_CAST_SKEWER			= 1
local MAGNATAUR_BOT_STATE_ATTACK			= 2
local MAGNATAUR_BOT_STATE_INACTIVE					= 3


-----------------------------------------------------------------------------------------------------

if CStatusEffectsMagnataurBot == nil then
	CStatusEffectsMagnataurBot = class({})
end

function CStatusEffectsMagnataurBot:constructor( me )
	self.me = me

	self.hAbilitySkewer = self.me:FindAbilityByName( "magnataur_skewer" )

	self.hSkewerLoc_1 = Entities:FindByName( nil, "enemy_spawn_location" )
	self.hSkewerLoc_2 = Entities:FindByName( nil, "enemy_spawn_location_2" )
	self.hSkewerLoc_3 = Entities:FindByName( nil, "enemy_spawn_location_3" )
	self.hLastSkewerLoc = Entities:FindByName( nil, "enemy_spawn_location_2" )
	self.fLastCastTime = GameRules:GetGameTime() - 5
	self.nBotState = MAGNATAUR_BOT_STATE_CAST_SKEWER

	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})

end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsMagnataurBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_sven" then
				self.hAttackTarget = hHero
				return
			end
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------

function CStatusEffectsMagnataurBot:BotThink()

	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.me:FindModifierByName("modifier_rod_of_atos_debuff") ~= nil then
		self.me:RemoveModifierByName("modifier_fountain_aura_buff")
		self.nBotState =  MAGNATAUR_BOT_STATE_ATTACK
		return -1
	end


	if self.nBotState == MAGNATAUR_BOT_STATE_IDLE then
		--do nothing

	 elseif self.nBotState == MAGNATAUR_BOT_STATE_CAST_SKEWER then

	 	if self.hLastSkewerLoc == self.hSkewerLoc_2 then
	 		self.hNextSkewerLoc = self.hSkewerLoc_1
	 	elseif self.hLastSkewerLoc == self.hSkewerLoc_1 then
	 		self.hNextSkewerLoc = self.hSkewerLoc_3
	 	else 
	 		self.hNextSkewerLoc = self.hSkewerLoc_2
	 	end

	 	self.hAbilitySkewer:EndCooldown()

		if self.hAbilitySkewer and self.hAbilitySkewer:IsFullyCastable() and GameRules:GetGameTime() >= self.fLastCastTime + 1.5 then
			self.fLastCastTime  = GameRules:GetGameTime()
				ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hAbilitySkewer:entindex(),
				Position = self.hNextSkewerLoc:GetAbsOrigin()
			} )

			self.hAbilitySkewer:RefundManaCost()
			self.hLastSkewerLoc = self.hNextSkewerLoc
		end

		return 1
	elseif self.nBotState == MAGNATAUR_BOT_STATE_ATTACK then 

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


	local hTask = GameRules.DotaNPX:GetTask( "root_enemy_hero" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		return -1
	end
		thisEntity:SetContextThink( "CStatusEffectsMagnataurBotThink", CStatusEffectsMagnataurBotThink, 1 )
		thisEntity.Bot = CStatusEffectsMagnataurBot( thisEntity )
	end
end

function CStatusEffectsMagnataurBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 1
end


