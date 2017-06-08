
---------------------------------------------------------------------------
-- Fire Trap Cycle
---------------------------------------------------------------------------

function OnTrigger( trigger )
	thisEntity.fRefireTime = 3.9

	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "Dungeon.TrapActivate", hTrigger )

	thisEntity.hBreatheFireAbility = thisEntity:FindAbilityByName( "breathe_fire" )
	if thisEntity.hBreatheFireAbility == nil then
		print( "ERROR: thisEntity.hBreatheFireAbility not found" )
		return
	end

	thisEntity:SetContextThink( "ActivateTrap", function() return FireTrapActivate() end, 0 )
end

---------------------------------------------------------------------------

function FireTrapActivate()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	return thisEntity.fRefireTime
end

---------------------------------------------------------------------------

