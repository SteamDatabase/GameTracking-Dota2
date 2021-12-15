acid_blob_jump = class({})
LinkLuaModifier( "modifier_acid_blob_jump", "modifiers/creatures/modifier_acid_blob_jump", LUA_MODIFIER_MOTION_BOTH )

-----------------------------------------------------------------------------------------

function acid_blob_jump:Precache( context )
	PrecacheResource( "particle", "particles/act_2/amoeba_marker.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
end

-------------------------------------------------------------------

function acid_blob_jump:OnAbilityPhaseStart()
	if IsServer() then
	
	end
	return true
end

-------------------------------------------------------------------

function acid_blob_jump:OnAbilityPhaseInterrupted()
	if IsServer() then
		
	end
end

-------------------------------------------------------------------

function acid_blob_jump:OnSpellStart()
	if IsServer() then

		local hDeathExplosionBuff = self:GetCaster():FindModifierByName( "modifier_acid_blob_death_explosion" )
		if hDeathExplosionBuff ~= nil then
			print( "SKIPPING BLOB JUMP ABILITY SINCE WE'RE DYING" )
			return
		end
		
		local kv =
		{
			vLocX = self:GetCursorPosition().x,
			vLocY = self:GetCursorPosition().y,
			vLocZ = self:GetCursorPosition().z
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_acid_blob_jump", kv )

		self.radius = self:GetSpecialValueFor( "radius" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.land_damage = self:GetSpecialValueFor( "land_damage" )

		self.nTargetFX = ParticleManager:CreateParticle( "particles/act_2/amoeba_marker.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nTargetFX, 0, self:GetCursorPosition() )
		ParticleManager:SetParticleControl( self.nTargetFX, 1, Vector( self.radius, -self.radius, -self.radius ) )
		ParticleManager:SetParticleControl( self.nTargetFX, 2, Vector( 0.8, 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( self.nTargetFX )
	end
end

-------------------------------------------------------------------

function acid_blob_jump:Smash()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nTargetFX, false )

		EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "OgreTank.GroundSmash", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
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

