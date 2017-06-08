--[[ units/ai/ai_forest_camp_captain.lua.lua ]]

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity:SetContextThink( "CaptainThink", CaptainThink, 1 )
		hSpawner = Entities:FindByName( nil, "forest_holdout_spawner_chief_vip" )
	end
end


function CaptainThink()
	if GameRules:IsGamePaused() or hSpawner == nil then
		return 1
	end
	
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	local flDist = ( thisEntity:GetOrigin() - hSpawner:GetOrigin() ):Length2D() 
	if #enemies == 0 then
		return ReturnToHome()
	end

	return 1
end


function ReturnToHome()
	if hSpawner == nil then
		print ( "Captain doesn't know where home is" )
		return
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetOrigin()
	})
	return 1
end
