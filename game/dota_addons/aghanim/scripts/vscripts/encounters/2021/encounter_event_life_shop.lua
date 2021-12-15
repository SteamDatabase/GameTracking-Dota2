require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_life_vendor" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_LifeShop == nil then
	CMapEncounter_Event_LifeShop = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_LifeShop:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_shard_shop_oracle", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_LifeShop:GetPreviewUnit()
	return "npc_dota_creature_shard_shop_oracle"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_LifeShop:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_LifeShop:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )
	
	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_roshan", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_LifeVendor( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_LifeShop
