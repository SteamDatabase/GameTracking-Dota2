
ogreseal_flop = class({})
LinkLuaModifier( "modifier_ogreseal_flop", "modifiers/creatures/modifier_ogreseal_flop", LUA_MODIFIER_MOTION_BOTH )

----------------------------------------------------------------------------------------

function ogreseal_flop:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/ogre_seal/ogre_seal_warcry.vpcf", context )

end

--------------------------------------------------------------------------------

function ogreseal_flop:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ogreseal_flop:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
	end

	return true
end

--------------------------------------------------------------------------------

function ogreseal_flop:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_2 )
		self:GetCaster():RemoveModifierByName( "modifier_techies_suicide_leap_animation" )
	end
end

--------------------------------------------------------------------------------

function ogreseal_flop:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ogreseal_flop", {} )
		if RandomFloat(0, 1) <= 0.2 then
			EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
		end
	end
end

--------------------------------------------------------------------------------

function ogreseal_flop:TryToDamage()
	if IsServer() then
		local radius = self:GetSpecialValueFor( "radius" )
		local base_damage = self:GetSpecialValueFor( "base_damage" )
		local damage_per_level = self:GetSpecialValueFor( "damage_per_level" )

		local nHeroLevel = self:GetCaster():GetOwnerEntity():GetLevel()
		local nDamage = base_damage + damage_per_level * nHeroLevel

		if nDamage > 0 then
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					if enemy ~= nil and enemy:IsNull() == false and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
						if not enemy:HasModifier("modifier_mounted") and not enemy:HasModifier("modifier_mount_hit_cooldown") then
							local DamageInfo =
							{
								victim = enemy,
								attacker = self:GetCaster(),
								ability = self,
								damage = nDamage,
								damage_type = self:GetAbilityDamageType(),
							}
							ApplyDamage( DamageInfo )
							if enemy:IsAlive() == false then
								local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
								ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
								ParticleManager:SetParticleControlTransformForward( nFXIndex, 1, enemy:GetOrigin(), -self:GetCaster():GetForwardVector() )
								ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
								ParticleManager:ReleaseParticleIndex( nFXIndex )

								EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
							else
								enemy:AddNewModifier( self:GetCaster(), self, "modifier_mount_hit_cooldown", { duration = 1 })
							end
						end
					end
				end
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre_seal/ogre_seal_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "mouth", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetCaster(), PATTACH_POINT_FOLLOW, "eye_L", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 7, self:GetCaster(), PATTACH_POINT_FOLLOW, "eye_R", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), radius, false )
	end
end

--------------------------------------------------------------------------------
