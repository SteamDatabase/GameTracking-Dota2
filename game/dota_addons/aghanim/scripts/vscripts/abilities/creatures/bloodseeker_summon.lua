
require( "utility_functions" )

--------------------------------------------------------------------------------

bloodseeker_summon = class({})

LinkLuaModifier(
	"modifier_bloodbound_bloodbag",
	"modifiers/creatures/modifier_bloodbound_bloodbag",
	LUA_MODIFIER_MOTION_HORIZONTAL
)

--------------------------------------------------------------------------------

function bloodseeker_summon:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/bloodseeker/bloodseeker_bloodbag_tracking.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_bloodbound_baby_ogre_magi", context, -1 )
end

--------------------------------------------------------------------------------

function bloodseeker_summon:Spawn()
	if IsServer() then
		self.hSummons = {}
		self.Projectiles = {}
	end
end

--------------------------------------------------------------------------------

function bloodseeker_summon:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.summon_interval = self:GetSpecialValueFor( "summon_interval" )
	self.pct_of_channel_to_summon = self:GetSpecialValueFor( "pct_of_channel_to_summon" )
	self.min_spawn_distance_pct_of_radius = self:GetSpecialValueFor( "min_spawn_distance_pct_of_radius" )
	self.travel_speed = self:GetSpecialValueFor( "travel_speed" )

	if IsServer() then
		--EmitSoundOnLocationWithCaster( self:GetCaster():GetCursorPosition(), "Boss_Tinker.Laser.Loop", self:GetCaster() )

		--self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 )

		printf( "bloodseeker_summon:OnSpellStart()" )

		self.nMinSpawnDistance = ( self.radius * ( self.min_spawn_distance_pct_of_radius / 100.0 ) )

		local fSummonDuration = ( self:GetChannelTime() * ( self.pct_of_channel_to_summon / 100.0 ) )
		self.fStopSummoningTime = GameRules:GetGameTime() + fSummonDuration

		self.fNextSummonTime = GameRules:GetGameTime() + self.summon_interval
	end
end

--------------------------------------------------------------------------------

function bloodseeker_summon:OnChannelThink( flInterval )
	if IsServer() then
		if GameRules:GetGameTime() >= self.fStopSummoningTime then
			return
		end

		if self.fNextSummonTime == nil or ( GameRules:GetGameTime() < self.fNextSummonTime ) then
			return
		end

		local vCasterPos = self:GetCaster():GetAbsOrigin()

		local vRandomOffset = Vector( RandomInt( -self.nMinSpawnDistance, self.radius ), RandomInt( -self.nMinSpawnDistance, self.radius ), 0 )
		local vSpawnPos = vCasterPos + vRandomOffset

		local nAttempts = 0
		local nMaxAttempts = 5
		while ( ( not GridNav:CanFindPath( self:GetCaster():GetOrigin(), vSpawnPos ) ) and ( nAttempts < 5 ) ) do
			vRandomOffset = Vector( RandomInt( -self.nMinSpawnDistance, self.radius ), RandomInt( -self.nMinSpawnDistance, self.radius ), 0 )
			vSpawnPos = vCasterPos + vRandomOffset
			nAttempts = nAttempts + 1

			if nAttempts >= 5 then
				vSpawnPos = vCasterPos
			end
		end

		local hBloodbag = CreateUnitByName( "npc_dota_creature_bloodbound_baby_ogre_magi", vCasterPos, true, nil, nil, self:GetCaster():GetTeamNumber() )
		if hBloodbag ~= nil and not hBloodbag:IsNull() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hSkeleteeny )
			ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPos )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			FindClearSpaceForUnit( hBloodbag, vSpawnPos, true )

			local kv_bloodbag =
			{
				duration = -1,
			}

			hBloodbag:AddNewModifier( self:GetCaster(), self, "modifier_bloodbound_bloodbag", kv_bloodbag )

			table.insert( self.hSummons, hBloodbag )
		end

		self.fNextSummonTime = GameRules:GetGameTime() + self.summon_interval
	end
end

-------------------------------------------------------------------------------

function bloodseeker_summon:OnProjectileThinkHandle( nProjectileHandle )
	if IsServer() then
		local projInfo = nil
		for _, v in pairs( self.Projectiles ) do
			if v.nProjectileHandle == nProjectileHandle then
				projInfo = v 
				break
			end
		end

		if projInfo == nil then
			printf( "ERROR - OnProjectileThinkHandle: projInfo not found" )
			return
		end

		local hBloodbag = projInfo.Source
		if hBloodbag == nil then
			printf( "ERROR - OnProjectileThinkHandle: hBloodbag not found" )
			return
		end

		if hBloodbag ~= nil and hBloodbag:IsNull() == false and hBloodbag:IsAlive() then
			local vLocation = ProjectileManager:GetTrackingProjectileLocation( projInfo.nProjectileHandle )
			hBloodbag:SetAbsOrigin( vLocation )

			local vToCaster = ( self:GetCaster():GetAbsOrigin() - hBloodbag:GetAbsOrigin() )
			local angles = VectorAngles( vToCaster )
			hBloodbag:SetAbsAngles( angles.x, angles.y, angles.z )
		end
	end
end

--------------------------------------------------------------------------------

function bloodseeker_summon:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		local projInfo = nil
		for _, v in pairs ( self.Projectiles ) do
			if v.nProjectileHandle == nProjectileHandle then
				projInfo = v
				break
			end
		end

		if projInfo == nil then
			printf( "ERROR - OnProjectileHitHandle: projInfo not found" )
			return false
		end

		if hTarget ~= nil then
			local hBloodseeker = hTarget

			local hBuff = hBloodseeker:FindModifierByName( "modifier_bloodseeker_engorge" )
			if hBuff ~= nil then
				hBuff:IncrementStackCount()
			end

			local hBloodbag = projInfo.Source

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hBloodbag, PATTACH_POINT_FOLLOW, "attach_hitloc", hBloodbag:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, hBloodbag:GetOrigin() )
			ParticleManager:SetParticleControlForward( nFXIndex, 1, -hBloodseeker:GetForwardVector() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 10, hBloodbag, PATTACH_ABSORIGIN_FOLLOW, nil, hBloodbag:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Dungeon.BloodSplatterImpact", hBloodbag )

			hBloodbag:ForceKill( false )

			return true
		end
	end

	return true
end

--------------------------------------------------------------------------------

function bloodseeker_summon:OnChannelFinish( bInterrupted )
	if IsServer() then
		--StopSoundOn( "Boss_Tinker.Laser", self:GetCaster() )

		--ParticleManager:DestroyParticle( self:GetCaster().nBeamFX, false )

		--self:GetCaster():FadeGesture( ACT_DOTA_OVERRIDE_ABILITY_3 )
	end
end

--------------------------------------------------------------------------------
