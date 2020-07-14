
---------------------------------------------------------------------------
-- Arrow Trap
---------------------------------------------------------------------------

function OnTrigger( trigger )
	if thisEntity.isTrapActivated then
		printf( "Trap Skip" )
		return
	end

	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "AghanimsFortress.TrapActivate", thisEntity )
	thisEntity.isTrapActivated = true

	thisEntity.hArrowAbility = thisEntity:FindAbilityByName( "arrow" )
	if thisEntity.hArrowAbility == nil then
		print( "ERROR: thisEntity.hArrowAbility not found" )
		return
	end

	local fDelay = 0.6
	thisEntity:SetContextThink( "ArrowTrapActivate", function() return ArrowTrapActivate() end, fDelay )
end

---------------------------------------------------------------------------

function ArrowTrapActivate()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity.isTrapActivated == true then
		thisEntity:SetAnimation( "bark_attack" );
		thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hArrowAbility, -1 )

		thisEntity.isTrapActivated = false
	end

	return -1
end

---------------------------------------------------------------------------
