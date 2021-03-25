
local STORM_SPIRITBOT_STATE_IDLE						= 0
local STORM_SPIRITBOT_STATE_CAST_SPELLS				= 1
local STORM_SPIRITBOT_STATE_TP							= 2 

-----------------------------------------------------------------------------------------------------

if CStatusEffectsStormSpiritBot == nil then
	CStatusEffectsStormSpiritBot = class({})
end

function CStatusEffectsStormSpiritBot:constructor( me )
	self.me = me

	self.hAbilityVortex = self.me:FindAbilityByName( "storm_spirit_electric_vortex" )
	self.hAbilityRemnant = self.me:FindAbilityByName( "storm_spirit_static_remnant" )
	self.hAbilityBallLightning = self.me:FindAbilityByName( "storm_spirit_ball_lightning" )
	self.bActivated = false
	self.hBallLightningLoc = Entities:FindByName( nil, "enemy_spawn_location_2" )
	self.nBotState = STORM_SPIRITBOT_STATE_IDLE
	self.hAttackTarget = nil

	for _,hTower in ipairs( Entities:FindAllByClassname( "ent_dota_fountain" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil


end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsStormSpiritBot:StartAI()
	if self.nBotState ~= STORM_SPIRITBOT_STATE_IDLE then
		return
	end

	self:ChangeBotState( STORM_SPIRITBOT_STATE_IDLE )
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsStormSpiritBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsStormSpiritBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_troll_warlord" then
				self.hAttackTarget = hHero
				return
			end
		end
	end
	return nil
end

function CStatusEffectsStormSpiritBot:BotThink()

	if not self.me:IsAlive() then
		return
	end

	if self.nBotState == STORM_SPIRITBOT_STATE_INACTIVE then
			if self.hAttackTarget ~= nil then
				UTIL_Remove(self.hAttackTarget )
			end
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


	if self.hAttackTarget == nil then
		self:FindBestTarget()
	end

	if self.hAttackTarget ~= nil and self.hAttackTarget:FindModifierByName("modifier_heavens_halberd_debuff") ~= nil and self.bActivated == false then

		self.me:RemoveModifierByName("modifier_bashed")
		self.me:RemoveModifierByName("modifier_troll_warlord_berserkers_rage_ensnare")
		self.me:AddItemByName("item_witch_blade")
		self.me:AddItemByName("item_bloodthorn")

		if self.hAbilityBallLightning ~= nil  and self.hAbilityBallLightning:IsFullyCastable() == true and self.bActivated == false then
			self.bActivated = true
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hAbilityBallLightning:entindex(),
				Position = self.hBallLightningLoc:GetAbsOrigin(),
				Queue = true
			} )

			self:ChangeBotState( STORM_SPIRITBOT_STATE_CAST_SPELLS )
			return 1.0
		end
	end

	if self.nBotState == STORM_SPIRITBOT_STATE_CAST_SPELLS then

		if self.hAttackTarget ~= nil and not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( STORM_SPIRITBOT_STATE_TP )	
			return
		end


		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			
			--[[if self.hAbilityVortex ~= nil and self.hAbilityVortex:IsFullyCastable() == true then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = self.hAbilityVortex:entindex(),
					TargetIndex = self.hAttackTarget:entindex(),
					Queue = false
				} )
			]]
			if self.hAbilityRemnant ~= nil and self.hAbilityRemnant:IsFullyCastable() == true then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self.hAbilityRemnant:entindex(),
					Queue = false
				} )
			else
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = self.hAttackTarget:entindex(),
					Queue = true
				} )
				return 1.0
			end
		else
			if self.hAbilityBallLightning ~= nil  and self.hAbilityBallLightning:IsFullyCastable() == true then
				
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = self.hAbilityBallLightning:entindex(),
					Position = self.hAttackTarget:GetAbsOrigin()
				} )
			end
			return
		end
	elseif self.nBotState == STORM_SPIRITBOT_STATE_TP then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTownPortalItem:entindex(),
			Position = self.hTpLocation:GetAbsOrigin(),
		} )
		
		if self.hTownPortalItem and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = STORM_SPIRITBOT_STATE_INACTIVE
			return -1
		end
	end
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "StatusEffectsStormSpiritBot", StatusEffectsStormSpiritBot, 0.5 )

		thisEntity.Bot = CStatusEffectsStormSpiritBot( thisEntity )
	end
end

function StatusEffectsStormSpiritBot()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5
end


