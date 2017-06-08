--[[ fire_trap_cycle_tripleshot.lua ]]

---------------------------------------------------------------------------
-- Fire Trap
---------------------------------------------------------------------------

function OnTrigger( trigger )
	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "Dungeon.TrapActivate", hTrigger )

	thisEntity.hBreatheFireAbility = thisEntity:FindAbilityByName( "breathe_fire" )
	if thisEntity.hBreatheFireAbility == nil then
		print( "ERROR: thisEntity.hBreatheFireAbility not found" )
		return
	end

	thisEntity.nTimesCast = 0
	thisEntity:SetContextThink( "ActivateTrap", function() return FireTrapActivate() end, 0 )
end

function FireTrapActivate()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local fRefireTime = 2.0
	local fQuickRefireTime = 0.5

	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity.nTimesCast = thisEntity.nTimesCast + 1

	if thisEntity.nTimesCast <= 2 then
		return fQuickRefireTime
	else
		thisEntity.nTimesCast = 0 -- reset counter
		return fRefireTime
	end

	return fRefireTime
end


