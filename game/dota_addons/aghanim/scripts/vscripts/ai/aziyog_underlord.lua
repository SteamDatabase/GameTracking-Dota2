

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	hFirestormAbility = thisEntity:FindAbilityByName( "aghsfort_aziyog_underlord_firestorm" )
	hPortalAbility = thisEntity:FindAbilityByName( "aghsfort_aziyog_underlord_dark_portal" )
	hWarpAbility = thisEntity:FindAbilityByName("aghsfort_aziyog_underlord_portal_warp")

	thisEntity:SetContextThink( "UnderlordThink", UnderlordThink, 1 )

	thisEntity.fLastPortalTime = GameRules:GetGameTime() - 30
	thisEntity.bHasCreatedDarkPortal = false
	thisEntity.nMaxAllowedPortalWalks = 3
	thisEntity.nCurrentPortalWalks = 0

end


function UnderlordThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end


	if thisEntity:IsChanneling() then
		return 1
	end

	local nDarkPortalClosestIndex = 0
	if thisEntity.bHasCreatedDarkPortal == false then

		
		local vDistanceToDarkPortalStart = 99999999
		for i = 1, 3 do 
			local startname = string.format( "dark_portal_start_%i", i )
			local hPortalStart = Entities:FindByName( nil, startname )
			if hPortalStart ~= nil then
				local vDistance = (thisEntity:GetOrigin() - hPortalStart:GetOrigin()):Length()
				if vDistance < vDistanceToDarkPortalStart then
					nDarkPortalClosestIndex = i
					vDistanceToDarkPortalStart = vDistance
				end
			end
		end

		local targetname = string.format( "dark_portal_target_%i", nDarkPortalClosestIndex )
		local hPortalTarget = Entities:FindByName( nil, targetname )
		if hPortalTarget ~= nil then
--			print("Creating Dark Portal at position ", nDarkPortalClosestIndex)

			ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = hPortalAbility:entindex(),
			Position = hPortalTarget:GetOrigin(),
			Queue = false,
			})
			thisEntity.bHasCreatedDarkPortal = true
		end
	end


	local hPortals = Entities:FindAllByClassnameWithin("npc_dota_unit_aziyog_underlord_portal", thisEntity:GetOrigin(), 800) 
	if hPortals ~= nil and #hPortals > 0 then
		for _, hPortal in pairs (hPortals) do
			if hPortal ~= nil and hPortal:GetOwner() ~= thisEntity and GameRules:GetGameTime() > thisEntity.fLastPortalTime + 20 and thisEntity:GetHealthPercent() < 45 and thisEntity.nCurrentPortalWalks <= thisEntity.nMaxAllowedPortalWalks then 
				ExecuteOrderFromTable( {
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hWarpAbility:entindex(),
				TargetIndex = hPortal:entindex(),
				Queue = false,
				} )
				thisEntity.fLastPortalTime = GameRules:GetGameTime()
				thisEntity.nCurrentPortalWalks = thisEntity.nCurrentPortalWalks + 1

				return 5
			end
		end
	end
	if hFirestormAbility ~= nil and hFirestormAbility:IsFullyCastable() then
		return CastFirestorm()
	end

	return 1



end


function CastFirestorm()

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hFirestormAbility:entindex(),
		Position = hEnemies[ RandomInt( 1, #hEnemies ) ]:GetOrigin(),
		Queue = false,
	})

	return 2
end
