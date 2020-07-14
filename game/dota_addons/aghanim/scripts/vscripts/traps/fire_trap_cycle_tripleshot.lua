
---------------------------------------------------------------------------
-- Fire Trap
---------------------------------------------------------------------------

function OnTrigger( trigger )
	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "AghanimsFortress.FireTrap", hTrigger )

	thisEntity.hBreatheFireAbility = thisEntity:FindAbilityByName( "breathe_fire" )
	if thisEntity.hBreatheFireAbility == nil then
		print( "ERROR: thisEntity.hBreatheFireAbility not found" )
		return
	end

	thisEntity.fRefireTime = 2.0
	thisEntity.fQuickRefireTime = 0.5

	thisEntity.nQuickRefires = 0
	thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fQuickRefireTime

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
		return QuickRefire()
	end

	return 0.25
end

---------------------------------------------------------------------------

function QuickRefire()
	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity.nQuickRefires = thisEntity.nQuickRefires + 1

	if thisEntity.nQuickRefires <= 2 then
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fQuickRefireTime
	else
		thisEntity.bNextAttackIsNormal = true
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime
		thisEntity.nQuickRefires = 0 -- reset counter
	end

	return 0.25
end

---------------------------------------------------------------------------

