if modifier_hero_respawn_time == nil then
	modifier_hero_respawn_time = class({})
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:OnCreated()
	--print( 'modifier_hero_respawn_time:OnCreated()' )
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		MODIFIER_PROPERTY_RESPAWNTIME
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:GetModifierPercentageRespawnTime( params )
	--print( 'modifier_hero_respawn_time:GetModifierPercentageRespawnTime ' .. _G.WINTER2022_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE )
	local flPct = 0
	if IsServer() then
		flPct = _G.WINTER2022_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" );
		if serverConstants ~= nil then
			flPct = serverConstants[ "WINTER2022_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE" ]
		end
	end
	return flPct
end

--------------------------------------------------------------------------------

function modifier_hero_respawn_time:GetModifierConstantRespawnTime( params )
	local nConstant = 0
	local flExtraPerSec = 0
	local flTimeLimit = 0
	local flTimePlayed = 0
	if IsServer() then
		nConstant = _G.WINTER2022_HERO_RESPAWN_TIME_CONSTANT
		flExtraPerSec = _G.WINTER2022_HERO_RESPAWN_TIME_EXTRA_TIME_PER_SECOND_PAST_LIMIT
		flTimeLimit = _G.WINTER2022_HERO_RESPAWN_TIME_EXTRA_TIME_TIME_LIMIT
		flTimePlayed = GameRules.Winter2022:GetPlayedTime()
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" )
		local flPregameTime = 0
		if serverConstants ~= nil then
			nConstant = serverConstants[ "WINTER2022_HERO_RESPAWN_TIME_CONSTANT" ]
			flExtraPerSec = serverConstants[ "WINTER2022_HERO_RESPAWN_TIME_EXTRA_TIME_PER_SECOND_PAST_LIMIT" ]
			flTimeLimit = serverConstants[ "WINTER2022_HERO_RESPAWN_TIME_EXTRA_TIME_TIME_LIMIT" ]
			flPregameTime = serverConstants[ "WINTER2022_PREGAME_TIME" ]
		end
		flTimePlayed = GameRules:GetDOTATime( false, true ) - flPregameTime
	end
	local flExtraTimeFromTime = math.max( 0, ( flTimePlayed - flTimeLimit ) * flExtraPerSec )
	local nTime = math.floor( nConstant + flExtraTimeFromTime )
	--print( 'modifier_hero_respawn_time:GetModifierConstantRespawnTime ' .. nTime .. ' with played time ' .. flTimePlayed .. ' and limit ' .. flTimeLimit .. ' so penalty ' .. flExtraTimeFromTime )
	return nTime
end
