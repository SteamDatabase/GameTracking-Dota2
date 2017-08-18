
LinkLuaModifier( "modifier_ogre_seal_surprise_passive", "modifiers/modifier_ogre_seal_surprise_passive", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hSurpriseSmash = thisEntity:FindAbilityByName( "ogre_seal_surprise_smash" )
	thisEntity.hFlop = thisEntity:FindAbilityByName( "ogreseal_flop" )
	thisEntity.flSearchRadius = 700
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_ogre_seal_surprise_passive", {surprise_radius = thisEntity.surprise_radius} )

	thisEntity:SetContextThink( "OgreSealThink", OgreSealThink, 1 )
end

--------------------------------------------------------------------------------

function OgreSealThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.flSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end
	-- Increase acquisition range after the initial aggro
	if ( not thisEntity.bAcqRangeModified ) then
		SetAggroRange( thisEntity, 850 )
		thisEntity.flSearchRadius = 850
	end

	if thisEntity:HasModifier( "modifier_ogre_seal_surprise_passive" ) then
		return SurprisePlayers( hEnemies[1] )
	end

	if thisEntity.hFlop ~= nil and thisEntity.hFlop:IsFullyCastable() then
		return CastBellyFlop( hEnemies[#hEnemies] )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastBellyFlop( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hFlop:entindex(),
		Position = thisEntity:GetOrigin() + thisEntity:GetForwardVector() * 50,
		Queue = false,
	})
	return 3
end

--------------------------------------------------------------------------------

function SurprisePlayers( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hSurpriseSmash:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 3 
end

--------------------------------------------------------------------------------

