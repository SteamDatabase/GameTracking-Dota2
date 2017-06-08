
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

	thisEntity:SetContextThink( "ActivateTrapNormal", function() return FireTrapActivateNormal() end, 0 )
end

---------------------------------------------------------------------------

function FireTrapActivateTriple()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local fQuickRefireTime = 0.5

	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity.nTimesCast = thisEntity.nTimesCast + 1

	if thisEntity.nTimesCast <= 2 then
		return fQuickRefireTime
	end

	thisEntity.nTimesCast = 0 -- reset counter
	thisEntity:SetContextThink( "ActivateTrapNormal", function() return FireTrapActivateNormal() end, 1.8 )
	return nil
end

---------------------------------------------------------------------------

function FireTrapActivateNormal()
	if not IsServer() then
		return
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity:SetContextThink( "ActivateTrapTriple", function() return FireTrapActivateTriple() end, 1.8 )
	return nil
end

---------------------------------------------------------------------------

