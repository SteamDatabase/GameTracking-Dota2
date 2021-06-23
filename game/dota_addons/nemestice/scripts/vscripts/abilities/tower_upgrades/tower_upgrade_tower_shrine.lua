
tower_upgrade_tower_shrine = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_tower_shrine_tracker", "modifiers/tower_upgrades/modifier_tower_upgrade_tower_shrine_tracker", LUA_MODIFIER_MOTION_NONE )

function tower_upgrade_tower_shrine:Precache( context )
	PrecacheResource( "particle", "particles/world_shrine/radiant_shrine_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/world_shrine/radiant_shrine_active.vpcf", context )
	PrecacheResource( "particle", "particles/world_shrine/radiant_shrine_regen.vpcf", context )
	PrecacheResource( "particle", "particles/world_shrine/dire_shrine_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/world_shrine/dire_shrine_active.vpcf", context )
	PrecacheResource( "particle", "particles/world_shrine/dire_shrine_regen.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_shrine:RequiresFacing()
	return false
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_shrine:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_shrine:OnSpellStart()
	if IsServer() == false then
		return
	end

	self:GetCaster().bHasRewardedKill = false

	EmitSoundOn( "Shrine.Cast", self:GetCaster() )
	--[[local nPlayerID = self:GetCaster().nLastCastingPlayerID
	local hPlayer = PlayerResource:GetPlayer( nPlayerID )
	local hHero = nil
	if hPlayer ~= nil then
		hHero = hPlayer:GetAssignedHero()
	end
	printf( "Shrine cast! Last controller = %d, so caster is %s", nPlayerID, ( hHero and hHero:GetUnitName() ) or "none" )
	--]]
	local kv = {}
	kv[ "duration" ] = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_filler_heal_aura", kv )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_tower_upgrade_tower_shrine_tracker", kv )

	local nTeam = self:GetCaster():GetTeamNumber()
	local teamShrines = GameRules.Nemestice.m_vecShrineHistory[ tostring( nTeam ) ]
	teamShrines[ tostring( math.floor( GameRules.Nemestice:GetPlayedTime() ) ) ] = true
	GameRules.Nemestice.m_vecShrineHistory[ tostring( nTeam ) ] = teamShrines

	GameRules.Nemestice.m_tShrinesUsed[ nTeam ] = GameRules.Nemestice.m_tShrinesUsed[ nTeam ] + 1
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_shrine:GetUpgradeBuildingName()
	return "npc_dota_nemestice_shrine"
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_shrine:GetBuildingType()
	return "shrine"
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_shrine:CreateAbilityReadyParticle( hBuilding )
	local szParticleName = "particles/world_shrine/radiant_shrine_ambient.vpcf"
	if hBuilding:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		szParticleName = "particles/world_shrine/dire_shrine_ambient.vpcf"
	end

	local nFX = ParticleManager:CreateParticle( szParticleName, PATTACH_ABSORIGIN_FOLLOW, hBuilding )
	return nFX
end
