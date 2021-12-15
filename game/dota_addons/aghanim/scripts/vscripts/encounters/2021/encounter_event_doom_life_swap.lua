require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_doom_life_swap" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_DoomLifeSwap == nil then
	CMapEncounter_Event_DoomLifeSwap = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_DoomLifeSwap:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_hero_doom_bringer", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_doom_bringer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_DoomLifeSwap:GetPreviewUnit()
	return "npc_dota_creature_doom_soultrader"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_DoomLifeSwap:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_DoomLifeSwap:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_doom", true )
	if hSpawner[ 1 ] then 
		print( "found the spawner" )
		local hDoomEventNPC = CEvent_NPC_DoomLifeSwap( hSpawner[ 1 ]:GetAbsOrigin() )
		if hDoomEventNPC then 
			self:AddInteractionNPC( hDoomEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_DoomLifeSwap
