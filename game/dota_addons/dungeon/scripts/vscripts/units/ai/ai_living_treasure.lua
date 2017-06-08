
--[[ units/ai/ai_living_treasure.lua ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "LivingTreasureThink", LivingTreasureThink, 1 )
end

--------------------------------------------------------------------------------

function LivingTreasureThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Are we faking?
	if thisEntity:HasModifier( "modifier_fake_treasure_chest" ) then
		return 0.5
	else
		print( "not faking anymore" )
		if ( not thisEntity.bSetRealBehaviors ) then
			print( "Change team, etc." )
			-- Change team, run away, etc
			thisEntity:SetTeam( DOTA_TEAM_BADGUYS )
			thisEntity.bSetRealBehaviors = true
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

