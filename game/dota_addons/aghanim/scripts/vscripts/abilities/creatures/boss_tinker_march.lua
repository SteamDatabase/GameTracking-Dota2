
boss_tinker_march = class({})

LinkLuaModifier( "modifier_boss_tinker_march_thinker",
	"modifiers/creatures/modifier_boss_tinker_march_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_march:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_motm.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/tinker_marching_machine.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_base_attack_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_keen_minion", context, -1 )
end

--------------------------------------------------------------------------------

function boss_tinker_march:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )
	self.splash_radius = self:GetSpecialValueFor( "splash_radius" )
	self.damage = self:GetSpecialValueFor( "damage" )

	if IsServer() then
		local vCursorPos = self:GetCursorPosition()

		local kv = { duration = self.duration }
		CreateModifierThinker( self:GetCaster(), self, "modifier_boss_tinker_march_thinker", kv, vCursorPos, self:GetCaster():GetTeamNumber(), false )

		EmitSoundOn( "Boss_Tinker.March.Cast", self:GetCaster() )
		EmitSoundOnLocationWithCaster( vCursorPos, "Boss_Tinker.March", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function boss_tinker_march:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if not self:GetCaster() or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
			return true
		end

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil,
			self.splash_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
			DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
		)

		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = self:GetAbilityDamageType(),
					ability = self,
				}

				ApplyDamage( damageInfo )
			end
		end

		if hTarget ~= nil and hTarget:IsNull() == false and hTarget:IsAlive() then
			local nImpactFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_razor/razor_base_attack_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nImpactFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nImpactFX )

			local TinkerAI = self:GetCaster().AI

			if TinkerAI and TinkerAI.KeenMinions and ( ( #TinkerAI.KeenMinions + 1 ) <= TinkerAI.nMaxKeenSpawns ) then
		 		local hKeenMinion = CreateUnitByName( "npc_dota_creature_keen_minion", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		 		if hKeenMinion then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hKeenMinion )
					ParticleManager:SetParticleControl( nFXIndex, 0, hKeenMinion:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "Boss_Tinker.March.SpawnMinion", hKeenMinion )

					table.insert( TinkerAI.KeenMinions, hKeenMinion )
				end
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------
