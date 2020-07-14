
aghsfort_waveblaster_summon_ghost = class({})
LinkLuaModifier( "modifier_aghsfort_waveblaster_summon_ghost_thinker", "modifiers/creatures/modifier_aghsfort_waveblaster_summon_ghost_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghsfort_waveblaster_summon_ghost:Precache( context )

	PrecacheResource( "particle", "particles/themed_fx/tower_dragon_black_smokering.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_zealot_mound", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_zealot_scarab", context, -1 )

end

--------------------------------------------------------------------------------

function aghsfort_waveblaster_summon_ghost:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghsfort_waveblaster_summon_ghost:OnSpellStart()
	if not IsServer() then
		return
	end

	if self:GetCaster() == nil or self:GetCaster():IsNull() then
		return
	end

	local nSummonCount = self:GetSpecialValueFor( "spawn_count" )
	local flSpawnDistance = self:GetSpecialValueFor( "spawn_distance" )
	local flDuration = self:GetSpecialValueFor( "spawn_delay" )
	local flDeltaAngle = 360 / nSummonCount
	local vAngles = QAngle( 0, math.random( 0, flDeltaAngle ), 0 )

	for i = 1,nSummonCount do

		local vSpawnPosition = nil
		for s = 1,36 do

			local vDir = AnglesToVector( vAngles )
			local vTest = self:GetCaster():GetAbsOrigin() + vDir * flSpawnDistance + math.random( -25, 25 )

			if GameRules.Aghanim:GetCurrentRoom():IsValidSpawnPoint( vTest ) then
				vSpawnPosition = vTest
				break
			end

			vAngles.y = vAngles.y + 10

		end

		vAngles.y = vAngles.y + flDeltaAngle + math.random( -20, 20 )

		if vSpawnPosition ~= nil then

			CreateModifierThinker( self:GetCaster(), self, "modifier_aghsfort_waveblaster_summon_ghost_thinker", {duration = flDuration }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )

		end

	end
end

--------------------------------------------------------------------------------
