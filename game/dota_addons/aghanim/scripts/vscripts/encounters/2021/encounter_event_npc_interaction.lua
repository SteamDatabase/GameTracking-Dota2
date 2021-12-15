require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )


--------------------------------------------------------------------------------

if CMapEncounter_Event_NPCInteraction == nil then
	CMapEncounter_Event_NPCInteraction = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:GetPreviewUnit()
	return "npc_dota_hero_doom_bringer"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.hEventNPCs = {} 
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:AddInteractionNPC( hEventNPC ) 
	table.insert( self.hEventNPCs, hEventNPC )
	local szObjective = tostring( "speak_to_" .. hEventNPC:GetEventNPCName() )
	self:AddEncounterObjective( szObjective, 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:ResetHeroStateOnEncounterComplete()
	return false 
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:OnComplete()
	CMapEncounter.OnComplete( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:GetEventNPCs()
	return self.hEventNPCs
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:HaveAllPlayersCompletedNPCInteractions()
	local bComplete = true 
	for _,hEventNPC in pairs ( self.hEventNPCs ) do 
		if not hEventNPC:HaveAllPlayersCompletedNPCInteractions() then 
			bComplete = false 
			break
		end
	end

	return bComplete
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NPCInteraction:CheckForCompletion()
	return true--self:HaveAllPlayersCompletedNPCInteractions()
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_NPCInteraction
