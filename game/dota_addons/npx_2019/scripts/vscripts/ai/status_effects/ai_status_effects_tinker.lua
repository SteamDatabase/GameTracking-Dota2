
local TINKER_BOT_STATE_IDLE						= 0
local TINKER_BOT_STATE_CAST_SPELLS				= 1
local TINKER_BOT_STATE_ATTACK					= 2 
local TINKER_BOT_STATE_INACTIVE					= 3

-----------------------------------------------------------------------------------------------------

if CStatusEffectsTinkerBot == nil then
	CStatusEffectsTinkerBot = class({})
end

function CStatusEffectsTinkerBot:constructor( me )
	self.me = me

	self.hAbilityLaser = self.me:FindAbilityByName( "tinker_laser" )
	self.hAbilityRearm = self.me:FindAbilityByName( "tinker_rearm" )
	self.bShootLaser = true
	self.nBotState = TINKER_BOT_STATE_IDLE
	self.hAttackTarget = nil
	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})
	self.hAbilityRearm:SetLevel(2)
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsTinkerBot:StartAI()
	if self.nBotState ~= TINKER_BOT_STATE_IDLE then
		return
	end
		printf("StartAI")
	self.nBotState =  TINKER_BOT_STATE_CAST_SPELLS
end


-----------------------------------------------------------------------------------------------------

function CStatusEffectsTinkerBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_drow_ranger" then
				self.hAttackTarget = hHero
				self.nBotState = TINKER_BOT_STATE_CAST_SPELLS
				return
			end
		end
	end
	return nil
end

function CStatusEffectsTinkerBot:BotThink()

	if self.hAttackTarget == nil then
		self:FindBestTarget()
	end

	if self.me:FindModifierByName("modifier_orchid_malevolence_debuff") ~= nil then
		self.me:RemoveModifierByName("modifier_fountain_aura_buff")
		self.nBotState =  TINKER_BOT_STATE_ATTACK

		local hBlind = self.hAttackTarget:FindModifierByName( "modifier_tinker_laser_blind" )
		if hBlind ~= nil and hBlind:GetRemainingTime() > 0.3 then
			self.hAttackTarget:RemoveModifierByName("modifier_tinker_laser_blind")
		end

		if self.hAttackTarget == nil then
			return
		else 
			ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex(),
			Queue = false,
			} )
			return
		end

		return 1
	end


	if self.nBotState == TINKER_BOT_STATE_INACTIVE then
		return -1
	end

	if self.nBotState == TINKER_BOT_STATE_IDLE then
		
		return

	elseif self.nBotState == TINKER_BOT_STATE_CAST_SPELLS then

		if self.hAttackTarget == nil or not self.hAttackTarget:IsAlive() then
			return
		end

	local nFXIndex = ParticleManager:CreateParticle( "particles/msg_fx/msg_evade.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self.me:GetAbsOrigin() + Vector(0, -64,96))
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(396, 0, 0 ))
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 3, 0 ))
	ParticleManager:SetParticleControl( nFXIndex, 3, Vector(250, 250, 220 ))
	ParticleManager:ReleaseParticleIndex( nFXIndex )


		if self.hAbilityLaser and self.hAbilityLaser:IsFullyCastable() then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = self.hAbilityLaser:entindex(),
					TargetIndex = self.hAttackTarget:entindex(),
				} )
			return 1
		elseif self.hAbilityRearm and self.hAbilityRearm:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityRearm:entindex(),
				Queue = true
			} )
			self.hAbilityRearm:RefundManaCost()
			return 1
		else 
			self.nBotState = TINKER_BOT_STATE_ATTACK
			return
		end
	elseif self.nBotState == TINKER_BOT_STATE_ATTACK then

		if self.hAttackTarget == nil then
			return
		else 

			ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex(),
			Queue = false,
			} )
			return
		end
	end

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then


	local hTask = GameRules.DotaNPX:GetTask( "silence_enemy_hero" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		return -1
	end

		thisEntity:SetContextThink( "StatusEffectsTinkerBot", StatusEffectsTinkerBot, 0.4 )
		thisEntity.Bot = CStatusEffectsTinkerBot( thisEntity )
	end
end

function StatusEffectsTinkerBot()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.4
end


