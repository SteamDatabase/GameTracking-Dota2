modifier_item_bogduggs_cudgel = class({})

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:OnCreated( kv )
	self.base_attack_time_penalty_pct = self:GetAbility():GetSpecialValueFor( "base_attack_time_penalty_pct" )
	self.attack_speed_penalty_pct = self:GetAbility():GetSpecialValueFor( "attack_speed_penalty_pct" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

	if self:GetParent():IsRangedAttacker() then
		self.flAttackSpeedReduction = 0
	else
		if self.flAttackSpeedReduction == nil then
			self.flAttackSpeedReduction = 0
		end
		
		self.flAttackSpeedReduction = ( ( self:GetParent():GetAttackSpeed() + self.flAttackSpeedReduction ) * self.attack_speed_penalty_pct ) / 100
	end
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end 

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:GetModifierAttackSpeedBonus_Constant( params )
	if self.flAttackSpeedReduction == nil then
		return 0
	end
	
	return -self.flAttackSpeedReduction * 100
end 

--------------------------------------------------------------------------------

function modifier_item_bogduggs_cudgel:OnAttackLanded( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.target
		
		if Attacker ~= nil and Attacker == self:GetParent() and Attacker:IsRangedAttacker() == false and Target ~= nil then
			EmitSoundOn( "OgreTank.GroundSmash.Lesser", Target )
			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, Attacker )
			ParticleManager:SetParticleControl( nFXIndex, 0, Target:GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.damage_radius, self.damage_radius, self.damage_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( Attacker:GetTeamNumber(), Target:GetOrigin(), Attacker, self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					if enemy ~= Target then
						local damageInfo = 
						{
							victim = enemy,
							attacker = Attacker,
							damage = params.original_damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self:GetAbility(),
						}
						ApplyDamage( damageInfo )
					end
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -Attacker:GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact.Lesser", enemy )
					else
						enemy:AddNewModifier( Attacker, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
					end
				end
			end
		end
	end

	if self:GetParent():IsRangedAttacker() then
		self.flAttackSpeedReduction = 0
	else
		if self.flAttackSpeedReduction == nil then
			self.flAttackSpeedReduction = 0
		end
		
		self.flAttackSpeedReduction = ( ( self:GetParent():GetAttackSpeed() + self.flAttackSpeedReduction ) * self.attack_speed_penalty_pct ) / 100
	end

	return 0
end

--------------------------------------------------------------------------------