require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_morphling_attribute_shift" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_MorphlingAttributeShift == nil then
	CMapEncounter_Event_MorphlingAttributeShift = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MorphlingAttributeShift:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_creature_morphling_event", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_morphling.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MorphlingAttributeShift:GetPreviewUnit()
	return "npc_dota_creature_morphling_event"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MorphlingAttributeShift:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MorphlingAttributeShift:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_morphling", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_MorphlingAttributeShift( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_MorphlingAttributeShift
