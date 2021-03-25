
local DARK_SEER_BOT_STATE_IDLE					= 0
local DARK_SEER_BOT_STATE_MOVE			= 1
local DARK_SEER_BOT_STATE_ATTACK			= 2
local DARK_SEER_BOT_STATE_INACTIVE					= 3


-----------------------------------------------------------------------------------------------------

if CStatusEffectsDarkSeerBot == nil then
	CStatusEffectsDarkSeerBot = class({})
end

function CStatusEffectsDarkSeerBot:constructor( me )
	self.me = me

	self.hAbilitySurge = self.me:FindAbilityByName( "dark_seer_surge" )

	self.hMoveLoc1 = Entities:FindByName( nil, "enemy_spawn_location" )
	self.hMoveLoc2 = Entities:FindByName( nil, "enemy_spawn_location_2" )
	self.hMoveLoc3 = Entities:FindByName( nil, "enemy_spawn_location_3" )
	self.hLastMoveLoc = Entities:FindByName( nil, "enemy_spawn_location" )
	self.bSvenActivated = false
	self.fLastCastTime = GameRules:GetGameTime() - 5
	self.nBotState = DARK_SEER_BOT_STATE_MOVE
	self.hAbilitySurge:SetLevel(4)
	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})

end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsDarkSeerBot:FindBestTarget()
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

function CStatusEffectsDarkSeerBot:BotThink()

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


		if self.hAttackTarget == nil then
			self:FindBestTarget()
		end
		if self.bSvenActivated == false then 
			self.hAttackTarget:AddItemByName("item_greater_crit")
			self.hAttackTarget:AddItemByName("item_assault")
			self.bSvenActivated = true
	  		ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.hAttackTarget:entindex(),
				Queue = false
				} )
	  	end

		self.nBotState =  DARK_SEER_BOT_STATE_ATTACK
		return 0.5
	end


	if self.nBotState == DARK_SEER_BOT_STATE_IDLE then
		--do nothing

	 elseif self.nBotState == DARK_SEER_BOT_STATE_MOVE then

	 	if self.hLastMoveLoc == self.hMoveLoc2 then
	 		self.hNextMoveLoc = self.hMoveLoc1
	 	elseif self.hLastMoveLoc == self.hMoveLoc1 then
	 		self.hNextMoveLoc = self.hMoveLoc3
	 	else 
	 		self.hNextMoveLoc = self.hMoveLoc2
	 	end


	 	if self.me:FindModifierByName("modifier_dark_seer_surge") == nil then
	 		self.hAbilitySurge:EndCooldown()
			if self.hAbilitySurge and self.hAbilitySurge:IsFullyCastable() and GameRules:GetGameTime() >= self.fLastCastTime + 1.5 then
				self.fLastCastTime  = GameRules:GetGameTime()
					ExecuteOrderFromTable( {
						UnitIndex = self.me:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = self.hAbilitySurge:entindex(),
						TargetIndex = self.me:entindex(),
					} )

				self.hAbilitySurge:RefundManaCost()
				return 1
			end
		end
		
		if self.me:IsMoving() == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.hNextMoveLoc:GetAbsOrigin()
			} )
			self.hLastMoveLoc = self.hNextMoveLoc
		end

		return 1
	end
	
	if self.nBotState == DARK_SEER_BOT_STATE_ATTACK then 

	if self.hAttackTarget == nil then
		self:FindBestTarget()
	end

  		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex(),
			Queue = false
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
		thisEntity:SetContextThink( "CStatusEffectsDarkSeerBotThink", CStatusEffectsDarkSeerBotThink, 0.5 )
		thisEntity.Bot = CStatusEffectsDarkSeerBot( thisEntity )
	end
end

function CStatusEffectsDarkSeerBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5
end


