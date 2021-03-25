require( "ai/objectives/ai_objectives_enemy_hero" )

-----------------------------------------------------------------------------------------------------

if CObjectivesPhantomLancerBot == nil then
	CObjectivesPhantomLancerBot = class( {}, {}, CObjectivesEnemyHeroBot )
end

-----------------------------------------------------------------------------------------------------

function CObjectivesPhantomLancerBot:constructor( me )
	CObjectivesEnemyHeroBot.constructor( self, me )

	self.hAbilitySpiritLance = self.me:FindAbilityByName( "phantom_lancer_spirit_lance" )
	self.hAbilityDoppelwalk = self.me:FindAbilityByName( "phantom_lancer_doppelwalk" )

end

function CObjectivesPhantomLancerBot:ConsiderUsingAbilitiesOnAttackTarget()
	
	if self.hAbilitySpiritLance and self.hAbilitySpiritLance:IsFullyCastable() then

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = self.hAttackTarget:entindex(),
			AbilityIndex = self.hAbilitySpiritLance:entindex(),
		})

		return self.hAbilitySpiritLance
	end

	if self.hAbilityDoppelwalk and self.hAbilityDoppelwalk:IsFullyCastable() then

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = self.hAttackTarget:GetOrigin(),
			AbilityIndex = self.hAbilityDoppelwalk:entindex()
		})

		return self.hAbilityDoppelwalk
	end

	return nil
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "ObjectivesPhantomLancerThink", ObjectivesPhantomLancerThink, 0.1 )

		thisEntity.Bot = CObjectivesPhantomLancerBot( thisEntity )
	end
end

function ObjectivesPhantomLancerThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


