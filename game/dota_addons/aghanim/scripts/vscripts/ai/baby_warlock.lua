
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	wordAbility = thisEntity:FindAbilityByName( "creature_warlock_shadow_word_bloodbound" )

	thisEntity:SetContextThink( "BabyWarlockThink", BabyWarlockThink, 1 )
end

--------------------------------------------------------------------------------

function BabyWarlockThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if wordAbility ~= nil and wordAbility:IsChanneling() then
		return 0.5
	end

	if wordAbility ~= nil and wordAbility:IsFullyCastable() then
		local nCastRange = wordAbility:GetCastRange( thisEntity:GetOrigin(), nil )
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nCastRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		-- two passes, first for Bloodseeker, next for Ogre
		for _,friendly in pairs ( friendlies ) do
			if friendly ~= nil then
				if ( friendly:GetUnitName() == "npc_dota_creature_bloodseeker" ) then
					return CastWord( friendly )
				end
			end
		end
		for _,friendly in pairs ( friendlies ) do
			if friendly ~= nil then
				if ( friendly:GetUnitName() == "npc_dota_creature_bloodbound_ogre_magi" ) then
					return CastWord( friendly )
				end
			end
		end

		-- fallback: pick an enemy
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nCastRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		for _,enemy in pairs ( enemies ) do
			if enemy ~= nil then
				return CastWord( enemy )
			end
		end
	end

	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation to these magi
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function CastWord( hUnit )
	--print( "Casting bloodlust on " .. hUnit:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = wordAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

