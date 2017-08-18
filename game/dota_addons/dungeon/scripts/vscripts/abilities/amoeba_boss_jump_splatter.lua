amoeba_boss_jump_splatter = class({})
LinkLuaModifier( "modifier_amoeba_boss_jump", "modifiers/modifier_amoeba_boss_jump", LUA_MODIFIER_MOTION_BOTH )

-------------------------------------------------------------------

function amoeba_boss_jump_splatter:OnAbilityPhaseStart()
	if IsServer() then
	
	end
	return true
end

-------------------------------------------------------------------

function amoeba_boss_jump_splatter:OnAbilityPhaseInterrupted()
	if IsServer() then
		
	end
end

-------------------------------------------------------------------

function amoeba_boss_jump_splatter:OnSpellStart()
	if IsServer() then
		
		local kv =
		{
			vLocX = self:GetCursorPosition().x,
			vLocY = self:GetCursorPosition().y,
			vLocZ = self:GetCursorPosition().z
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_amoeba_boss_jump", kv )

		self.radius = self:GetSpecialValueFor( "radius" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.land_damage = self:GetSpecialValueFor( "land_damage" )
		self.splatter_speed = self:GetSpecialValueFor( "splatter_speed" )
		self.splatter_min_distance = self:GetSpecialValueFor( "splatter_min_distance" )
		self.splatter_max_distance = self:GetSpecialValueFor( "splatter_max_distance" )
		self.splatter_damage = self:GetSpecialValueFor( "splatter_damage" )
		self.splatter_radius = self:GetSpecialValueFor( "splatter_radius" )
		self.slow_duration = self:GetSpecialValueFor( "slow_duration" )

		local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_boss_passive" )
		if hBuff ~= nil then
			if hBuff:GetStackCount() <= 50 and hBuff:GetStackCount() > 25 then
				self.radius = self.radius / 2
				self.land_damage = self.land_damage / 2
				self.stun_duration = self.stun_duration / 2
			end
			if hBuff:GetStackCount() < 25 then
				self.radius = self.radius / 4
				self.land_damage = self.land_damage / 4
				self.stun_duration = 0.01
			end
		end
		self.nTargetFX = ParticleManager:CreateParticle( "particles/act_2/amoeba_marker.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nTargetFX, 0, self:GetCursorPosition() )
		ParticleManager:SetParticleControl( self.nTargetFX, 1, Vector( self.radius, -self.radius, -self.radius ) )
		ParticleManager:SetParticleControl( self.nTargetFX, 2, Vector( 0.8, 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( self.nTargetFX )
	end
end

-------------------------------------------------------------------

function amoeba_boss_jump_splatter:Splatter()
	if IsServer() then
		self.nStackCount = 0
		self.Thinkers = {}
		local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_boss_passive" )
		if hBuff ~= nil then
			self.nStackCount = hBuff:GetStackCount()
			self.nStacksToLaunch = math.min( 10, math.floor( self.nStackCount / 2 ) )
			if self.nStackCount <= 50 then
				self.nStacksToLaunch = 0 
			end

			while self.nStacksToLaunch > 0 do	
				local vPos = self:GetCaster():GetOrigin() + RandomVector( 1 ) * RandomFloat( self.splatter_min_distance, self.splatter_max_distance )
				local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_amoeba_blob_launch_thinker", { duration = -1 }, vPos, self:GetCaster():GetTeamNumber(), false )
				if hThinker ~= nil then
					table.insert( self.Thinkers, hThinker )	
					local info = 
					{
						Target = hThinker,
						Source = self:GetCaster(),
						Ability = self,
						EffectName = "particles/act_2/amoeba_blob_launch_no_arc.vpcf",
						iMoveSpeed = self.splatter_speed,
						vSourceLoc = self:GetCaster():GetOrigin(),
						bDodgeable = false,
						bProvidesVision = false,
					}

					ProjectileManager:CreateTrackingProjectile( info )
					EmitSoundOn( "Hero_Bristleback.ViscousGoo.Target", self:GetCaster() )
					self.nStacksToLaunch = self.nStacksToLaunch - 1
				--	hBuff:DecrementStackCount()
				end
			end
		end

		ParticleManager:DestroyParticle( self.nTargetFX, false )

		EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "OgreTank.GroundSmash", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:GetCaster():Interrupt()

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.land_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self,
				}

				ApplyDamage( damageInfo )

				if enemy:IsAlive() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
				else
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
				end
			end
		end
	end
end

-----------------------------------------------------------------------------

function amoeba_boss_jump_splatter:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			for i=1,#self.Thinkers do
				local hThinker = self.Thinkers[i]
				if hThinker ~= nil and hThinker == hTarget then
					table.remove( self.Thinkers, i )
					UTIL_Remove( hThinker )
				end
			end

			EmitSoundOnLocationWithCaster( vLocation, "Hero_Batrider.StickyNapalm.Impact", self:GetCaster() )	

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.splatter_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _,hEnemy in pairs( enemies ) do
				if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self.splatter_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}
					ApplyDamage( damageInfo )
					local hStickyDebuff = hEnemy:FindModifierByName( "modifier_amoeba_boss_ink" )
					if hStickyDebuff == nil then
						hStickyDebuff = hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_amoeba_boss_ink", { duration = self.slow_duration } )
						if hStickyDebuff ~= nil then
							hStickyDebuff:SetStackCount( 1 )
						end
					else
						hStickyDebuff:SetStackCount( hStickyDebuff:GetStackCount() + 1 )
					end
				end
			end
			
			local hAmoeba = CreateUnitByName( "npc_dota_creature_sub_amoeba_boss", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			if hAmoeba ~= nil then
				if self:GetCaster().zone ~= nil then
					self:GetCaster().zone:AddEnemyToZone( hAmoeba )
				end	
				local hBuff = hAmoeba:FindModifierByName( "modifier_amoeba_boss_passive" )
				if hBuff ~= nil then
					hBuff:SetStackCount( 1 )
				end
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, vLocation )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.splatter_radius, self.splatter_radius, self.splatter_radius  ) )
				ParticleManager:SetParticleControlEnt( nFXIndex, 2, hAmoeba, PATTACH_POINT_FOLLOW, "attach_hitloc", hAmoeba:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end
	end
	return true
end
