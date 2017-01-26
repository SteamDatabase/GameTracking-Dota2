--[[ Night Stalker AI ]]

function Spawn( entityKeyValues )
	if not GameRules:IsNightstalkerNight() then
    	thisEntity:SetContextThink( "NightstalkerThink", WaitToCastDarkness, 0.25 )
	end
end

function NightstalkerThink()
	-- Check again whether it's daytime
	if not GameRules:IsNightstalkerNight() then
		print( "Nightstalker casting Darkness" )
		Ability_darkness = thisEntity:FindAbilityByName( "creature_night_stalker_darkness" )
		if Ability_darkness and Ability_darkness:IsTrained() and Ability_darkness:IsFullyCastable() then
			thisEntity:CastAbilityNoTarget( Ability_darkness, -1 )
		else
			return 0.25
		end
	end

	return 0.25
end
