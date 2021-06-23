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
	--print( 'modifier_hero_respawn_time:GetModifierPercentageRespawnTime ' .. _G.NEMESTICE_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE )
	local flPct = 0
	if IsServer() then
		flPct = _G.NEMESTICE_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" );
		if serverConstants ~= nil then
			flPct = serverConstants[ "NEMESTICE_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE" ]
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
		nConstant = _G.NEMESTICE_HERO_RESPAWN_TIME_CONSTANT
		flExtraPerSec = _G.NEMESTICE_HERO_RESPAWN_TIME_EXTRA_TIME_PER_SECOND_PAST_LIMIT
		flTimeLimit = _G.NEMESTICE_HERO_RESPAWN_TIME_EXTRA_TIME_TIME_LIMIT
		flTimePlayed = GameRules.Nemestice:GetPlayedTime()
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" );
		if serverConstants ~= nil then
			nConstant = serverConstants[ "NEMESTICE_HERO_RESPAWN_TIME_CONSTANT" ]
			flExtraPerSec = serverConstants[ "NEMESTICE_HERO_RESPAWN_TIME_EXTRA_TIME_PER_SECOND_PAST_LIMIT" ]
			flTimeLimit = serverConstants[ "NEMESTICE_HERO_RESPAWN_TIME_EXTRA_TIME_TIME_LIMIT" ]
		end
	end
	local flExtraTimeFromTime = math.max( 0, ( flTimePlayed - flTimeLimit ) * flExtraPerSec )
	local nTime = math.floor( nConstant + flExtraTimeFromTime )
	--print( 'modifier_hero_respawn_time:GetModifierConstantRespawnTime ' .. nTime .. ' with played time ' .. flTimePlayed .. ' and limit ' .. flTimeLimit .. ' so penalty ' .. flExtraTimeFromTime )
	return nTime
end
