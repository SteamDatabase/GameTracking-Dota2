require( "ai/ai_laning" )

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LinaMid1v1Think", LinaMid1v1Think, 0.25 )	

		thisEntity.LaningAI = CDotaAILaning( LAST_HIT_AI_SKILL.EASY, LAST_HIT_AI_TYPE.BALANCED, thisEntity )
		thisEntity.LaningAI:SetLastHitHoverRange( 100.0 + thisEntity:Script_GetAttackRange() )
	end
end

function LinaMid1v1Think()
	if IsServer() == false then
		return -1
	end

	if GameRules:IsGamePaused() then
		return 0.1
	end
	
	return thisEntity.LaningAI:DoLaning()
end
