require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_tinker_range_retrofit" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_TinkerRangeRetrofit == nil then
	CMapEncounter_Event_TinkerRangeRetrofit = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_TinkerRangeRetrofit:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_tinker_event", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_laser.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_ambient.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_tinker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_TinkerRangeRetrofit:GetPreviewUnit()
	return "npc_dota_creature_tinker_event"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_TinkerRangeRetrofit:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_TinkerRangeRetrofit:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_tinker", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_Tinker_RangeRetrofit( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_TinkerRangeRetrofit
