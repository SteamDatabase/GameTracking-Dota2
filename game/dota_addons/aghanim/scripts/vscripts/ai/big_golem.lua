
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	RockGolemSmashAbility = thisEntity:FindAbilityByName( "aghsfort_rock_golem_smash" )

	thisEntity:SetContextThink( "BigGolemThink", BigGolemThink, 0.25 )
end

--------------------------------------------------------------------------------

function BigGolemThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local fSmashSearchRadius = RockGolemSmashAbility:GetCastRange() 
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fSmashSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.25
	end

	if RockGolemSmashAbility ~= nil and RockGolemSmashAbility:IsCooldownReady() then
		local hTarget = enemies[ RandomInt( 1, #enemies ) ]
		return CastRockSmash( hTarget )
	end

	return 0.25
end

--------------------------------------------------------------------------------

function CastRockSmash( hTarget )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.3 } )
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = RockGolemSmashAbility:entindex(),
		Position = hTarget:GetAbsOrigin(),
		Queue = false,
	})

	return 2.0
end

--------------------------------------------------------------------------------
