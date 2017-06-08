mini_weaver_bug_attack = class({})
LinkLuaModifier( "modifier_mini_weaver_bug_attack", "modifiers/modifier_mini_weaver_bug_attack", LUA_MODIFIER_MOTION_HORIZONTAL )

------------------------------------------------------------------------

function mini_weaver_bug_attack:OnSpellStart()
	if IsServer() then
		local count = self:GetSpecialValueFor( "count" )
		local speed = self:GetSpecialValueFor( "speed" )
		local radius = self:GetSpecialValueFor( "radius" )
		local spawn_radius = self:GetSpecialValueFor( "spawn_radius" )

		local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vDirection = vDirection:Normalized()

		local info = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf",
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), nil ),
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = vDirection * speed,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			bProvidesVision = true,
			iVisionRadius = radius,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		}

		for i=0,count do 
			info.vSpawnOrigin = self:GetCaster():GetOrigin() + RandomVector( spawn_radius )
			ProjectileManager:CreateLinearProjectile( info )
		end

		EmitSoundOn( "Hero_Weaver.Swarm.Cast", self:GetCaster() )
	end
end

------------------------------------------------------------------------

function mini_weaver_bug_attack:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsInvulnerable() == false and hTarget:FindModifierByName( "modifier_weaver_swarm_debuff" ) == nil then
			local hUnit = CreateUnitByName( "npc_dota_weaver_swarm", hTarget:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
			if hUnit ~= nil then
				if self:GetCaster().zone ~= nil then
					self:GetCaster().zone:AddEnemyToZone( hUnit )
				end

				EmitSoundOn( "Hero_Weaver.SwarmAttach", hTarget )

				local kv =
				{
					entindex = hTarget:entindex(),
					duration = -1,
				}

				hTarget:AddNewModifier( self:GetCaster(), self, "modifier_weaver_swarm_debuff", {} )
				hUnit:AddNewModifier( self:GetCaster(), self, "modifier_mini_weaver_bug_attack", kv )
				return true
			end
		end
	end

	return false
end

------------------------------------------------------------------------