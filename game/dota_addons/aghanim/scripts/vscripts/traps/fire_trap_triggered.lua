
---------------------------------------------------------------------------
-- Fire Trap
---------------------------------------------------------------------------

function OnTrigger( trigger )
	if thisEntity.isTrapActivated then
		print( "Trap Skip" )
		return
	end

	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "AghanimsFortress.FireTrap", thisEntity )
	thisEntity.isTrapActivated = true

	thisEntity.hBreatheFireAbility = thisEntity:FindAbilityByName( "breathe_fire" )
	if thisEntity.hBreatheFireAbility == nil then
		print( "ERROR: thisEntity.hBreatheFireAbility not found" )
		return
	end

	thisEntity:SetContextThink( "ActivateTrap", function() return FireTrapActivate() end, 0 )
end

function FireTrapActivate()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity.isTrapActivated == true then
		--[[
		print( "----------------------------------------------------------" )
		print( "FireTrapActivate... thisEntity:" )
		PrintTable( thisEntity, "   " )
		]]

		thisEntity:SetAnimation( "bark_attack" );
		thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

		thisEntity.isTrapActivated = false
	end

	return -1
end

