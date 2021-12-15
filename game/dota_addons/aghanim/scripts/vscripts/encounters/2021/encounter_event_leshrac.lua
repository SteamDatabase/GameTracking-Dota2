
require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_leshrac" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_Leshrac == nil then
	CMapEncounter_Event_Leshrac = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Leshrac:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheUnitByNameSync( self:GetPreviewUnit(), context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Leshrac:GetPreviewUnit()
	return "npc_dota_creature_event_leshrac"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Leshrac:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Leshrac:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_leshrac", true )
	if hSpawner[ 1 ] then 
		--printf( "found the spawner" )
		local hLeshracEventNPC = CEvent_NPC_Leshrac( hSpawner[ 1 ]:GetAbsOrigin() )
		if hLeshracEventNPC then 
			self:AddInteractionNPC( hLeshracEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_Leshrac
