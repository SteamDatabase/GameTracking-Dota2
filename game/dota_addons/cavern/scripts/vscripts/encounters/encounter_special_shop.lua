require( "cavern_encounter" )

if encounter_special_shop == nil then
	encounter_special_shop = class({},{},CCavernEncounter)
end

--------------------------------------------------------------------

function encounter_special_shop:GetEncounterType()
	return CAVERN_ROOM_TYPE_SHOP
end

--------------------------------------------------------------------

function encounter_special_shop:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_special_shop:Start()

	CCavernEncounter.Start( self )
	
	local Shop = self:SpawnNonCreepByName( "npc_dota_cavern_shop", self.hRoom:GetRoomCenter(), true, nil, nil, DOTA_TEAM_NEUTRALS )
	if Shop ~= nil then
	 	Shop:SetAbsOrigin( GetGroundPosition( self.hRoom:GetRoomCenter(), Shop ) )
	 	Shop:SetShopType( DOTA_SHOP_HOME )
	 	local Trigger = SpawnDOTAShopTriggerRadiusApproximate( Shop:GetOrigin(), CAVERN_SHOP_RADIUS )
	 	if Trigger then
	 		Trigger:SetShopType( DOTA_SHOP_HOME )
	 	end
	end
	return true
end
--------------------------------------------------------------------
