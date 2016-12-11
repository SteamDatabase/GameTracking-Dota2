--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
--
--=============================================================================
require( "game/dkjson" )

function HasBaseClass( object, baseClass )
    while ( object ~= nil ) do
		if ( object == baseClass ) then
			return true
		end
		local mt = getmetatable( object )
		if mt == nil then
			return false
		end
		object = mt.__index
	end
	return false
end


-- Backwards compatability glue.
if PrecacheUnitByNameSync ~= nil then
	PrecacheUnitByNameSync_Engine = PrecacheUnitByNameSync
	PrecacheUnitByNameSync = function( szUnitName, hContext, nPlayerID )
		if nPlayerID == nil then
			nPlayerID = -1
		end
		PrecacheUnitByNameSync_Engine( szUnitName, hContext, nPlayerID )
	end
end

if PrecacheUnitByNameAsync ~= nil then
	PrecacheUnitByNameAsync_Engine = PrecacheUnitByNameAsync
	PrecacheUnitByNameAsync = function( szUnitName, hCallback, nPlayerID)
		if nPlayerID == nil then
			nPlayerID = -1
		end
		PrecacheUnitByNameAsync_Engine( szUnitName, hCallback, nPlayerID )
	end
end

if CDOTABaseAbility ~= nil then		
	-- Ensure we always pass enough arguments to GetCastRange.
	-- Passing nil as target is fine.
	CDOTABaseAbility.GetCastRange_Engine = CDOTABaseAbility.GetCastRange
	CDOTABaseAbility.GetCastRange = function( self, vLocation, hTarget )
		if vLocation == nil then
			vLocation = Vector( 0, 0, 0 )
		end
		return CDOTABaseAbility.GetCastRange_Engine( self, vLocation, hTarget )
	end

	CDOTABaseAbility.IsCosmetic_Engine = CDOTABaseAbility.IsCosmetic
	CDOTABaseAbility.IsCosmetic = function( self, hTarget )
		return CDOTABaseAbility.IsCosmetic_Engine( self, hTarget )
	end
end

if CBaseEntity ~= nil then
	CBaseEntity.IsBaseNPC = function ( self ) return false end
end

if CDOTA_BaseNPC ~= nil then
	CDOTA_BaseNPC.IsHardDisarmed = function( self ) 
		print( "CDOTA_BaseNPC.IsHardDisarmed is deprecated, please call IsDisarmed." )
		return CDOTA_BaseNPC.IsDisarmed( self )
	end
	CDOTA_BaseNPC.IsSoftDisarmed = function( self ) 
		print( "CDOTA_BaseNPC.IsSoftDisarmed is deprecated, please call IsDisarmed." )
		return CDOTA_BaseNPC.IsDisarmed( self )
	end
	CDOTA_BaseNPC.IsBaseNPC = function ( self ) return true end
end

if CDOTA_BaseNPC_Hero ~= nil then
	CDOTA_BaseNPC_Hero.AddExperience_Engine = CDOTA_BaseNPC_Hero.AddExperience
	CDOTA_BaseNPC_Hero.AddExperience = function( self, flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal )
		if bIncrementTotal == nil then
			-- Argument added in the middle of the parameters.
			bIncrementTotal = bApplyBotDifficultyScaling
			bApplyBotDifficultyScaling = nReason
			nReason = DOTA_ModifyXP_Unspecified
		end
		return CDOTA_BaseNPC_Hero.AddExperience_Engine( self, flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal )
	end

	CDOTA_BaseNPC_Hero.IncrementDeaths_Engine = CDOTA_BaseNPC_Hero.IncrementDeaths
	CDOTA_BaseNPC_Hero.IncrementDeaths = function( self, nKillerID )
		if nKillerID == nil then
			nKillerID = -1
		end
		return CDOTA_BaseNPC_Hero.IncrementDeaths_Engine( self, nKillerID )
	end
end

if CDOTA_PlayerResource ~= nil then
	CDOTA_PlayerResource.GetCreepDamageTaken_Engine = CDOTA_PlayerResource.GetCreepDamageTaken
	CDOTA_PlayerResource.GetCreepDamageTaken = function( self, nPlayerID, bTotal )
		if bTotal == nil then
			bTotal = false
		end
		return CDOTA_PlayerResource.GetCreepDamageTaken_Engine( self, nPlayerID, bTotal )
	end

	CDOTA_PlayerResource.GetHeroDamageTaken_Engine = CDOTA_PlayerResource.GetHeroDamageTaken
	CDOTA_PlayerResource.GetHeroDamageTaken = function( self, nPlayerID, bTotal )
		if bTotal == nil then
			bTotal = false
		end
		return CDOTA_PlayerResource.GetHeroDamageTaken_Engine( self, nPlayerID, bTotal )
	end
	
	CDOTA_PlayerResource.GetTowerDamageTaken_Engine = CDOTA_PlayerResource.GetTowerDamageTaken
	CDOTA_PlayerResource.GetTowerDamageTaken = function( self, nPlayerID, bTotal )
		if bTotal == nil then
			bTotal = false
		end
		return CDOTA_PlayerResource.GetTowerDamageTaken_Engine( self, nPlayerID, bTotal )
	end

	CDOTA_PlayerResource.IncrementDeaths_Engine = CDOTA_PlayerResource.IncrementDeaths
	CDOTA_PlayerResource.IncrementDeaths = function( self, nPlayerID, nKillerID )
		if nKillerID == nil then
			nKillerID = -1
		end
		return CDOTA_PlayerResource.IncrementDeaths_Engine( self, nPlayerID, nKillerID )
	end

	CDOTA_PlayerResource.GetEventPremiumPointsGranted = CDOTA_PlayerResource.GetEventPremiumPoints
 	CDOTA_PlayerResource.GetEventRankGranted = CDOTA_PlayerResource.GetEventRanks

	CDOTA_PlayerResource.IncrementTotalEarnedXP_Engine = CDOTA_PlayerResource.IncrementTotalEarnedXP
	CDOTA_PlayerResource.IncrementTotalEarnedXP = function( self, nPlayerID, nXP, nReason )
		if nReason == nil then
			nReason = DOTA_ModifyXP_Unspecified
		end
		return CDOTA_PlayerResource.IncrementTotalEarnedXP_Engine( self, nPlayerID, nXP, nReason )
	end

	CDOTA_PlayerResource.HeroLevelUp = function( self, nPlayerID )
		print("DEPRICATED FUNCTION CALLED: PlayerResource:HeroLevelUp, remove before the end of BETA to prevent script errors")
	end
end

-- Lua ability binding glue-
if CDOTA_Ability_Lua ~= nil then
	CDOTA_Ability_Lua.CastFilterResult_Engine = CDOTA_Ability_Lua.CastFilterResult
	CDOTA_Ability_Lua.CastFilterResult = function( self, param )
		if getmetatable( param ) == Vector then
			return CDOTA_Ability_Lua.CastFilterResultLocation( self, param )
		elseif param ~= nil then
			return CDOTA_Ability_Lua.CastFilterResultTarget( self, param )
		else
			return CDOTA_Ability_Lua.CastFilterResult_Engine( self )
		end
	end

	CDOTA_Ability_Lua.GetCustomCastError_Engine = CDOTA_Ability_Lua.GetCustomCastError
	CDOTA_Ability_Lua.GetCustomCastError = function( self, param )
		if getmetatable( param ) == Vector then
			return CDOTA_Ability_Lua.GetCustomCastErrorLocation( self, param )
		elseif param ~= nil then
			return CDOTA_Ability_Lua.GetCustomCastErrorTarget( self, param )
		else
			return CDOTA_Ability_Lua.GetCustomCastError_Engine( self )
		end
	end
end

if LinkLuaModifier ~= nil then
	LinkLuaModifier_Engine = LinkLuaModifier
	function LinkLuaModifier( modifierName, fileName, modifierType )
		if modifierType == nil then
			return LinkLuaModifier_Engine( modifierName, modifierName, fileName )
		else
			return LinkLuaModifier_Engine( modifierName, fileName, modifierType )
		end
	end
end