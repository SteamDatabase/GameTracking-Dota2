require( "npx_scenario" )

--------------------------------------------------------------------

if CDotaNPXScenario_Explore == nil then
	CDotaNPXScenario_Explore = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Explore:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_phantom_assassin",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingItems 		=
		{
		},

		ScenarioTimeLimit = 0, -- Not timed.
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_Explore:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	-- Disable passive gold income
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetGoldTickTime( 100 )
	-- Quick respawns
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 5 )
	-- Start with creeps on the map
	GameRules:ForceCreepSpawn()

	-- Weaken all the enemy towers
	local enemyUnits = FindUnitsInRadius( self.hPlayerHero:GetTeamNumber(), Vector( 0,0,0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )	
	for _,hEnemy in pairs( enemyUnits ) do
		if hEnemy:IsTower() then
			hEnemy:SetMaxHealth( 1000 )
			hEnemy:SetHealth( hEnemy:GetMaxHealth() )
		end
	end

	-- Strengthen all the allied towers
	local allyUnits = FindUnitsInRadius( self.hPlayerHero:GetTeamNumber(), Vector( 0,0,0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )	
	for _,hAlly in pairs( allyUnits ) do
		if hAlly:IsTower() then
			hAlly:SetMaxHealth( 100000 )
			hAlly:SetHealth( hAlly:GetMaxHealth() )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Explore:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	
	hCourier = self.hPlayerHero:AddItemByName( 'item_courier' )
	self.hPlayerHero:CastAbilityImmediately( hCourier, -1 )


	local nAbilityCount = self.hPlayerHero:GetAbilityCount()
	for i = 0, nAbilityCount-1 do
		if self.hPlayerHero:GetAbilityPoints() > 0 then
			local hAbility = self.hPlayerHero:GetAbilityByIndex( i )
			if hAbility ~= nil then
				if hAbility:CanAbilityBeUpgraded() then
					self.hPlayerHero:UpgradeAbility( hAbility )
				end
			end
		end
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_Explore