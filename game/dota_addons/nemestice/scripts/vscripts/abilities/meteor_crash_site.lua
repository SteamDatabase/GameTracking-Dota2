
meteor_crash_site = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_meteor_crash_site_thinker", "modifiers/modifier_meteor_crash_site_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_meteor_crash_site_thinker_sound", "modifiers/modifier_meteor_crash_site_thinker_sound", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function meteor_crash_site:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
	PrecacheResource( "particle", "particles/gameplay/spring_meteor_explosion_start/spring_meteor_explosion_start.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/spring_meteor_explosion/spring_meteor_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/tower_mortar_marker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", context )
end

--------------------------------------------------------------------------------

function meteor_crash_site:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function meteor_crash_site:OnSpellStart()
	if IsServer() == false then
		return
	end

	local vSpawnPos = self:GetCursorPosition()
	vSpawnPos = GetGroundPosition( vSpawnPos, self:GetCaster() )
	local meteor_delay = self:GetSpecialValueFor( "meteor_delay" )
	local flDuration = meteor_delay
	if self.flExtraDelay ~= nil then
		flDuration = flDuration + self.flExtraDelay
	end
	--print( "Created meteor at pos ( " .. vSpawnPos.x .. ", " .. vSpawnPos.y .. ", " .. vSpawnPos.z .. ")" )

	local kv = {}
	kv[ "duration" ] = flDuration
	kv[ "create_item_team" ] = self.nCreateItemTeam
	kv[ "meteor_size" ] = self.nMeteorSize
	if self.bFakeCinemticCrash then
		kv[ "fake_cinematic_crash" ] = 1
	else
		kv[ "fake_cinematic_crash" ] = 0
	end
	PrintTable( kv )
	CreateModifierThinker( self:GetCaster(), self, "modifier_meteor_crash_site_thinker", kv, vSpawnPos, self:GetCaster():GetTeamNumber(), false )
end

