
require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_zeus" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_Zeus == nil then
	CMapEncounter_Event_Zeus = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Zeus:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", context )
	PrecacheUnitByNameSync( self:GetPreviewUnit(), context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Zeus:GetPreviewUnit()
	return "npc_dota_creature_event_zeus"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Zeus:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Zeus:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_zeus", true )
	if hSpawner[ 1 ] then 
		--printf( "found the spawner" )
		local hZeusEventNPC = CEvent_NPC_Zeus( hSpawner[ 1 ]:GetAbsOrigin() )
		if hZeusEventNPC then 
			self:AddInteractionNPC( hZeusEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_Zeus
