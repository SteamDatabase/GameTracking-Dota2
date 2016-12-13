
require( GetScriptDirectory().."/mode_defend_ally_generic" )

----------------------------------------------------------------------------------------------------

function OnStart()
	-- Do the standard OnStart
	mode_generic_defend_ally.OnStart();
end

----------------------------------------------------------------------------------------------------

function OnEnd()
	-- Do the standard OnEnd
	mode_generic_defend_ally.OnEnd();
end

----------------------------------------------------------------------------------------------------

function Think()

	local npcBot = GetBot();

	-- Do the standard Think
	mode_generic_defend_ally.Think()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() ) then return end;
	
	-- If we have a target and can cast LSA on them, do so
	if ( npcBot:GetTarget() ~= nil ) then
		abilityLSA = npcBot:GetAbilityByName( "lina_light_strike_array" );
		if ( abilityLSA:IsFullyCastable() )
		then
			npcBot:Action_UseAbilityOnLocation( abilityLSA, npcBot:GetTarget():GetLocation() );
		end
	end
end

----------------------------------------------------------------------------------------------------

function GetDesire()

	local npcBot = GetBot();
	local fBonus = 0.0;

	-- If we have a target and can cast Light Strike Array, our desire to help defend should be higher than normal
	if ( npcBot:GetTarget() ~= nil )
	then
		abilityLSA = npcBot:GetAbilityByName( "lina_light_strike_array" );
		if ( abilityLSA:IsFullyCastable() )
		then
			fBonus = 0.25;
		end
	end

	return Clamp( mode_generic_defend_ally.GetDesire() + fBonus, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_ABSOLUTE );
end

----------------------------------------------------------------------------------------------------

