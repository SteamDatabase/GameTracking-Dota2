
local TINKER_BOT_STATE_IDLE					= 0
local TINKER_BOT_STATE_CAST_MISSILES		= 1
local TINKER_BOT_STATE_CAST_REARM			= 2
local TINKER_BOT_STATE_TP					= 3
local TINKER_BOT_STATE_INACTIVE				= 4


-----------------------------------------------------------------------------------------------------

if CDodgingTinkerBot == nil then
	CDodgingTinkerBot = class({})
end

function CDodgingTinkerBot:constructor( me )
	self.me = me

	self.hAbilityMissiles = self.me:FindAbilityByName( "tinker_heat_seeking_missile" )
	self.hAbilityRearm = self.me:FindAbilityByName( "tinker_rearm" )


	self.nBotState = TINKER_BOT_STATE_IDLE

	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})

	for _,hTower in ipairs( Entities:FindAllByClassname( "ent_dota_fountain" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil
	self.LastMissileTime = GameRules:GetGameTime() - 6

end


function CDodgingTinkerBot:BotThink()

	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.nBotState == TINKER_BOT_STATE_INACTIVE then
		self.me:RemoveSelf()
		return -1
	end

	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end
	self.me:SetHealth( self.me:GetMaxHealth() )
	
	local hTask = GameRules.DotaNPX:GetTask( "dodge_all_missiles_1" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		self.nBotState = TINKER_BOT_STATE_TP
	end

	if self.nBotState == TINKER_BOT_STATE_IDLE then

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self.nBotState = TINKER_BOT_STATE_CAST_MISSILE
		else
			return 1
		end


	elseif self.nBotState == TINKER_BOT_STATE_CAST_MISSILE then
		self.hAbilityMissiles:EndCooldown()		

	 	local vDirection = self.hAttackTarget:GetAbsOrigin() - self.me:GetAbsOrigin()

 		self.me:SetForwardVector(vDirection)
		if self.hAbilityMissiles ~= nil and self.hAbilityMissiles:GetLevel() > 0 and self.hAbilityMissiles:IsFullyCastable() and GameRules:GetGameTime() >= self.LastMissileTime + 3.5 then
			
			-- refresh the player 
			RefreshHero( self.hAttackTarget)
			self.hAttackTarget:RemoveModifierByName("modifier_invulnerable")
			local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self.hAttackTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hAttackTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hAttackTarget:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )


				ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityMissiles:entindex(),
				Queue = true
			} )
			self.LastMissileTime = GameRules:GetGameTime()
			self.nBotState = TINKER_BOT_STATE_CAST_REARM
			self.hAbilityMissiles:RefundManaCost()
		end

		return 1

	 elseif self.nBotState == TINKER_BOT_STATE_CAST_REARM then

	 	self.hAbilityRearm:EndCooldown()

		if self.hAbilityRearm and self.hAbilityRearm:IsFullyCastable() then
	
			
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityRearm:entindex(),
				Queue = true
			} )
			self.nBotState = TINKER_BOT_STATE_CAST_MISSILE
		end
		self.hAbilityRearm:RefundManaCost()

		return 3
	elseif self.nBotState == TINKER_BOT_STATE_TP then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTownPortalItem:entindex(),
			Position = self.hTpLocation:GetAbsOrigin(),
		} )
		
		if self.hTownPortalItem and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = TINKER_BOT_STATE_INACTIVE
			return -1
		end
	end
	return 3
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "CDodgingTinkerBotThink", CDodgingTinkerBotThink, 1 )

		thisEntity.Bot = CDodgingTinkerBot( thisEntity )
	end
end

function CDodgingTinkerBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 1
end


