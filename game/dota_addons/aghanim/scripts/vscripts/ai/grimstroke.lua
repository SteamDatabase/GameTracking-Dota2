
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.fMaxSearchRange = 800

	thisEntity.hInkSwellAbility = thisEntity:FindAbilityByName( "aghsfort_grimstroke_spirit_walk" )

	thisEntity:SetContextThink( "GrimstrokeThink", GrimstrokeThink, 0.5 )
end

--------------------------------------------------------------------------------

function GrimstrokeThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fMaxSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.hInkSwellAbility and thisEntity.hInkSwellAbility:IsFullyCastable() then
		local hInkSwellTarget = nil
		local fInkSwellRange = thisEntity.hInkSwellAbility:GetCastRange()
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fInkSwellRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, friendly in pairs ( friendlies ) do
			if friendly ~= nil and friendly ~= thisEntity and friendly:GetUnitName() ~= "npc_dota_crate" then
				hInkSwellTarget = friendly
				if ( friendly:GetUnitName() == "npc_dota_creature_life_stealer" ) then
					break
				end
			end
		end

		if hInkSwellTarget then
			return CastInkSwell( hInkSwellTarget )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastInkSwell( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hInkSwellAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------
