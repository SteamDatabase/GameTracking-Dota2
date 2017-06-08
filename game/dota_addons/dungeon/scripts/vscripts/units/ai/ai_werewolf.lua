function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	HowlAbility = thisEntity:FindAbilityByName( "werewolf_howl" )
	thisEntity:SetContextThink( "WerewolfThink", WerewolfThink, 1 )
end

function WerewolfThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #friendlies == 0 then
		return 1
	end

	if HowlAbility ~= nil and HowlAbility:IsCooldownReady() then
		return Howl()
	end
	
	return 0.5
end


function Howl()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = HowlAbility:entindex(),
	})
	return 1
end

