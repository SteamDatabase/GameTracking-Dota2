--[[
Broodmother Spawn Logic
]]

function Spawn( entityKeyValues )
	ABILITY_spawn_spider = thisEntity:FindAbilityByName( "creature_spawn_spider" )
	thisEntity:SetContextThink( "BroodmotherThink", BroodmotherThink, 0.25 )

	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = Entities:FindByNameNearest( "path_invader*", thisEntity:GetOrigin(), 0 )
	if waypoint then
		thisEntity:SetInitialGoalEntity( waypoint )
		thisEntity:MoveToPositionAggressive( waypoint:GetOrigin() )
	else
		local ancient =  Entities:FindByName( nil, "dota_goodguys_fort" )
		thisEntity:SetInitialGoalEntity( ancient )
		thisEntity:MoveToPositionAggressive( ancient:GetOrigin() )
	end
end

function BroodmotherThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_spawn_spider:IsFullyCastable() then
		thisEntity:CastAbilityImmediately( ABILITY_spawn_spider, -1 )
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end