
---------------------------------------------------------------------------
-- Stone Trap
---------------------------------------------------------------------------

function OnTrigger( trigger )

	if thisEntity.isTrapActivated then
		print( "Trap Skip" )
		return
	end

	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "Dungeon.TrapActivate", thisEntity )
	thisEntity.isTrapActivated = true

	thisEntity.hStoneBoulderAbility = thisEntity:FindAbilityByName( "stone_boulder" )
	if thisEntity.hStoneBoulderAbility == nil then
		print( "ERROR: thisEntity.hStoneBoulderAbility not found" )
		return
	end

	thisEntity:SetContextThink( "StoneTrapActivate", function() return StoneTrapActivate() end, 0 )
end

---------------------------------------------------------------------------

function StoneTrapActivate()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity.isTrapActivated == true then
		--[[
		print( "----------------------------------------------------------" )
		print( "StoneTrapActivate... thisEntity:" )
		PrintTable( thisEntity, "   " )
		]]

		thisEntity:SetAnimation( "bark_attack" );
		thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hStoneBoulderAbility, -1 )

		thisEntity.isTrapActivated = false
	end

	return -1
end

---------------------------------------------------------------------------

