function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.flLastAbilityTime = GameRules:GetGameTime()
	thisEntity.flAbilityPauseTime = 3.0
	thisEntity.nWardsSummoned = 0

	thisEntity.WardSpawnLocations = Entities:FindAllByName( "spawner_ward" )

	thisEntity.NetherblastAbility = thisEntity:FindAbilityByName( "aghsfort_pugna_grandmaster_netherblast" )
	thisEntity.WardAbility = thisEntity:FindAbilityByName( "aghsfort_pugna_grandmaster_nether_ward" )
	thisEntity.LifeDrainAbility = thisEntity:FindAbilityByName( "pugna_life_drain" )
	thisEntity.LastUsedAbility = thisEntity.LifeDrainAbility
	thisEntity.bHasInitializedNoHealing = false
	thisEntity:SetContextThink( "PugnaGrandmasterThink", PugnaGrandmasterThink, 1 )

end




function PugnaGrandmasterThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end


	if thisEntity:IsChanneling() then
		return 1
	end
	if GameRules:GetGameTime() <= thisEntity.flLastAbilityTime  + thisEntity.flAbilityPauseTime then
		return 1
	end

	if thisEntity.nWardsSummoned == 0 and thisEntity:GetHealthPercent() < 80 then
		printf('thisEntity:GetHealthPercent() < 80 ')
		return SummonWards(1)
	end

	if thisEntity.nWardsSummoned == 1 and thisEntity:GetHealthPercent() < 60 then
		printf('thisEntity:GetHealthPercent() < 60 ')
		return SummonWards(2)
	end

	if thisEntity.nWardsSummoned == 3 and thisEntity:GetHealthPercent() < 40 then
		printf('thisEntity:GetHealthPercent() < 40 ')
		return SummonWards(4)
	end

	if thisEntity.NetherblastAbility ~= nil and thisEntity.NetherblastAbility:IsFullyCastable() and thisEntity.LastUsedAbility == thisEntity.LifeDrainAbility then

		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 
			thisEntity.NetherblastAbility:GetCastRange(thisEntity:GetOrigin(), nil), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #enemies > 0 then 
			return NetherBlast( enemies[ RandomInt( 1, #enemies ) ] )
		else
			thisEntity.LastUsedAbility = thisEntity.NetherblastAbility
		end

	end

	if thisEntity.LifeDrainAbility ~= nil and thisEntity.LifeDrainAbility:IsFullyCastable() and thisEntity.LastUsedAbility == thisEntity.NetherblastAbility then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 
			thisEntity.LifeDrainAbility:GetCastRange(thisEntity:GetOrigin(), nil), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

			if thisEntity.bHasInitializedNoHealing == false then
				local hAbility = thisEntity:AddAbility( "ability_absolute_no_healing" )
				if hAbility then
					hAbility:UpgradeAbility( false )
				end
				thisEntity.bHasInitializedNoHealing = true
			end


		if #enemies > 0 then 
			return LifeDrainAbility( enemies[ RandomInt( 1, #enemies ) ] )
		else
			thisEntity.LastUsedAbility = thisEntity.LifeDrainAbility
		end

	end

	return 1
end

function NetherBlast( hTarget )

	local vTargetPos = hTarget:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.NetherblastAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})
	thisEntity.flLastAbilityTime = GameRules:GetGameTime()
	thisEntity.LastUsedAbility = thisEntity.NetherblastAbility
	return 0.5
end

function LifeDrainAbility( hTarget )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.LifeDrainAbility:entindex(),
		TargetIndex  = hTarget:entindex(),
		Queue = false,
	})
	thisEntity.flLastAbilityTime = GameRules:GetGameTime()
	thisEntity.LastUsedAbility = thisEntity.LifeDrainAbility
	return 0.5
end


function SummonWards( nAmount )
	thisEntity:Purge( false, true, false, true, true )
	thisEntity.WardSpawnLocations = Entities:FindAllByName( "spawner_ward" )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_absolute_no_cc", { duration = -1 } )
	--Kill off all current wards
	local hCurrentWards = Entities:FindAllByName("npc_dota_base_additive")
	for _,ward in pairs(hCurrentWards) do
		printf('killing ward')
		ward:ForceKill(false)
	end
	local bQueue = false

	for i = 1, nAmount do
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = thisEntity.WardAbility:entindex(),
			Position = thisEntity.WardSpawnLocations[i]:GetAbsOrigin(),
			Queue = bQueue,
		})
		bQueue = true
		thisEntity.nWardsSummoned = thisEntity.nWardsSummoned + 1
	end
	
	thisEntity:RemoveModifierByName( 'modifier_absolute_no_cc')
	return 0.5
end