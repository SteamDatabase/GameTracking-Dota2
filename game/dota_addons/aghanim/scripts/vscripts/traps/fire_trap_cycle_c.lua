
---------------------------------------------------------------------------
-- Fire Trap Cycle
---------------------------------------------------------------------------

function OnTrigger( trigger )
	thisEntity.fRefireTime = 2.5

	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "AghanimsFortress.FireTrap", hTrigger )

	thisEntity.hBreatheFireAbility = thisEntity:FindAbilityByName( "breathe_fire" )
	if thisEntity.hBreatheFireAbility == nil then
		print( "ERROR: thisEntity.hBreatheFireAbility not found" )
		return
	end

	thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime

	thisEntity:SetContextThink( "ActivateTrap", function() return FireTrapActivate() end, 0 )
end

---------------------------------------------------------------------------

function DisableTrap( trigger )
	thisEntity.bDisabled = true
end

---------------------------------------------------------------------------

function FireTrapActivate()
	if not IsServer() then
		return
	end

	if thisEntity.bDisabled then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if GameRules:GetGameTime() >= thisEntity.fNextAttackTime then
		thisEntity:SetAnimation( "bark_attack" );
		thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime
	end

	return 0.5
end

---------------------------------------------------------------------------

