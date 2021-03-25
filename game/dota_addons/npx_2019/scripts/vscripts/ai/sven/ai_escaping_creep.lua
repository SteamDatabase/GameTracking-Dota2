
--[[ ai/sven/ai_escaping_creep.lua ]]

--------------------------------------------------------------------------------



function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	thisEntity:SetContextThink( "EscapingCreepThink", EscapingCreepThink, 0.1 )	
end

--------------------------------------------------------------------------------

function EscapingCreepThink()
	if not IsServer() then
		return
	end
	
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.1
	end
	
	if ( thisEntity.nShouldRunAway ) then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = Vector( 176.738, -1330.3, 128 )
		})	
	end
	
	return 0.1
end

--------------------------------------------------------------------------------
