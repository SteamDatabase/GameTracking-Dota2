
require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_small_tiny_shrink" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_SmallTinyShrink == nil then
	CMapEncounter_Event_SmallTinyShrink = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_SmallTinyShrink:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheUnitByNameSync( self:GetPreviewUnit(), context, -1 )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_SmallTinyShrink:GetPreviewUnit()
	return "npc_dota_creature_event_small_tiny"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_SmallTinyShrink:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_SmallTinyShrink:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_tiny", true )
	if hSpawner[ 1 ] then 
		--printf( "found the spawner" )
		local hTinyEventNPC = CEvent_NPC_SmallTiny_Shrink( hSpawner[ 1 ]:GetAbsOrigin() )
		if hTinyEventNPC then 
			self:AddInteractionNPC( hTinyEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_SmallTinyShrink
