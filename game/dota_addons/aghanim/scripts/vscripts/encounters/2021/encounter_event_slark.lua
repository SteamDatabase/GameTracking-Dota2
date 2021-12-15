
require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_slark" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_Slark == nil then
	CMapEncounter_Event_Slark = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Slark:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheUnitByNameSync( self:GetPreviewUnit(), context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Slark:GetPreviewUnit()
	return "npc_dota_creature_event_slark"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Slark:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_Slark:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_slark", true )
	if hSpawner[ 1 ] then 
		print( "found the spawner" )
		local hSlarkEventNPC = CEvent_NPC_Slark( hSpawner[ 1 ]:GetAbsOrigin() )
		if hSlarkEventNPC then 
			self:AddInteractionNPC( hSlarkEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_Slark
