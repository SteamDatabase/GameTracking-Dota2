
----------------------------------------------------------------------------------------------------

_G._savedEnv = getfenv()
module( "mode_generic_defend_ally", package.seeall )

----------------------------------------------------------------------------------------------------

function OnStart()
	--print( "mode_generic_defend_ally.OnStart" );
end

----------------------------------------------------------------------------------------------------

function OnEnd()
	--print( "mode_generic_defend_ally.OnEnd" );
end

----------------------------------------------------------------------------------------------------

function Think()
	--print( "mode_generic_defend_ally.Think" );
end

----------------------------------------------------------------------------------------------------

function GetDesire()

	local npcBot = GetBot();

	local fBestDefendScore = 0;
	local npcBestDefendableAlly = nil;
	local npcBestAttackingEnemy = nil;
	
	local tableNearbyRetreatingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_RETREAT );
	if ( #tableNearbyRetreatingAlliedHeroes == 0 )
	then
		return BOT_MODE_DESIRE_NONE;
	end

	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE );

	-- Is there a good enemy to attack, who's scary to our ally and not too scary to us?
	for _,npcAlly in pairs( tableNearbyRetreatingAlliedHeroes )
	do
		local fDefendScore, npcEnemy = GetDefendScore( npcAlly, tableNearbyEnemyHeroes );

		if ( fDefendScore > fBestDefendScore )
		then
			fBestDefendScore = fDefendScore;
			npcBestDefendableAlly = npcAlly;
			npcBestAttackingEnemy = npcEnemy;
		end
	end

	return RemapValClamped( fBestDefendScore, 0.0, 1.0, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_HIGH );
end

----------------------------------------------------------------------------------------------------

function GetDefendScore( npcAlly, tableNearbyEnemyHeroes )

	local nTotalEstimatedDamageToAlly = 0;
	local nTotalEstimatedDamageToMe = 0;
	local nMostEstimatedDamage = 0;
	local npcMostDangerousEnemy = nil;

	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		local nEstimatedDamageToAlly = npcEnemy:GetEstimatedDamageToTarget( false, npcAlly, 3.0, DAMAGE_TYPE_ALL );
		local nEstimatedDamageToMe = npcEnemy:GetEstimatedDamageToTarget( false, GetBot(), 3.0, DAMAGE_TYPE_ALL );

		nTotalEstimatedDamageToAlly = nTotalEstimatedDamageToAlly + nEstimatedDamageToAlly;
		nTotalEstimatedDamageToMe = nTotalEstimatedDamageToMe + nEstimatedDamageToMe;

		if ( nEstimatedDamageToAlly > nMostEstimatedDamage )
		then
			nMostEstimatedDamage = nEstimatedDamageToAlly;
			npcMostDangerousEnemy = npcEnemy;
		end
	end

	if ( npcMostDangerousEnemy ~= nil )
	then
		local fDefendAllyDesire = RemapValClamped( nTotalEstimatedDamageToAlly / npcAlly:GetHealth(), 0.5, 1.5, 0.0, 1.0 );
		local fSelfPreservationDesire = RemapValClamped( nTotalEstimatedDamageToMe / npcAlly:GetHealth(), 0.5, 1.5, 1.0, 0.0 );

		return 0.5 * fDefendAllyDesire * fSelfPreservationDesire, npcMostDangerousEnemy;
	end

	return 0, nil;
end

----------------------------------------------------------------------------------------------------

for k,v in pairs( mode_generic_defend_ally ) do	_G._savedEnv[k] = v end

----------------------------------------------------------------------------------------------------
