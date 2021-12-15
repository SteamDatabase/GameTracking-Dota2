
require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_leshrac" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_Necrophos == nil then
	CMapEncounter_Event_Necrophos = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Necrophos:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheUnitByNameSync( self:GetPreviewUnit(), context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Necrophos:GetPreviewUnit()
	return "npc_dota_creature_event_necrophos"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Necrophos:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Necrophos:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_necrophos", true )
	if hSpawner[ 1 ] then 
		--printf( "found the spawner" )
		local hNecrophosEventNPC = CEvent_NPC_Necrophos( hSpawner[ 1 ]:GetAbsOrigin() )
		if hNecrophosEventNPC then 
			self:AddInteractionNPC( hNecrophosEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_Necrophos
