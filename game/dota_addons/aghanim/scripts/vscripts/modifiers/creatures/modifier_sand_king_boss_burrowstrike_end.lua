modifier_sand_king_boss_burrowstrike_end = class ({})

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:OnCreated( kv )
	if IsServer() then
		self.vDir = Vector( kv["x"], kv["y"], kv["z"] )

		local flHealthPct = self:GetParent():GetHealthPercent() / 100
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" ) + ( self:GetAbility():GetSpecialValueFor( "scaling_speed" ) * ( 1 - flHealthPct ) )

		self.delay = self:GetAbility():GetSpecialValueFor( "delay" ) 
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )

		self.bExitGround = false

		self:StartIntervalThink( 0.1 )
		

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:OnIntervalThink()
	if IsServer() then
		if self.bExitGround == false then
			EmitSoundOn( "SandKingBoss.BurrowStrike", self:GetParent() )
			
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					local kv =
					{
						center_x = self:GetParent():GetOrigin().x,
						center_y = self:GetParent():GetOrigin().y,
						center_z = self:GetParent():GetOrigin().z,
						should_stun = true, 
						duration = self.stun_duration,
						knockback_duration = self.stun_duration,
						knockback_distance = self.knockback_distance,
						knockback_height = self.knockback_height,
					}
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
					local vDirection = enemy:GetOrigin() - self:GetParent():GetOrigin()
					vDirection.z = 0.0
					vDirection = vDirection:Normalized()

					ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end	
			self.bExitGround = true
			self:StartIntervalThink( self.delay - 0.1 )
		else
			local nFXCastIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXCastIndex, 1, Vector( self.radius, self.radius, self.radius ) )
			ParticleManager:ReleaseParticleIndex( nFXCastIndex )
			EmitSoundOn( "Burrower.Explosion", self:GetCaster() )

			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					local kv =
					{
						center_x = self:GetParent():GetOrigin().x,
						center_y = self:GetParent():GetOrigin().y,
						center_z = self:GetParent():GetOrigin().z,
						should_stun = true, 
						duration = self.stun_duration,
						knockback_duration = self.stun_duration,
						knockback_distance = self.knockback_distance,
						knockback_height = self.knockback_height,
					}
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
					local vDirection = enemy:GetOrigin() - self:GetParent():GetOrigin()
					vDirection.z = 0.0
					vDirection = vDirection:Normalized()

					ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
			self:Destroy()
		end	
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vNewLocation = self:GetParent():GetOrigin() + self.vDir * ( self.speed / 2 ) * dt
		me:SetOrigin( vNewLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end


--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:CheckState()
	if IsServer() then
		local state =
		{
			[MODIFIER_STATE_INVISIBLE] = self.bExitGround ~= true,
			[MODIFIER_STATE_STUNNED] = true,
		}
	end
	return state
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:GetModifierDisableTurning( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:GetOverrideAnimation( params )
	return ACT_DOTA_SAND_KING_BURROW_OUT
end

-------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:GetOverrideAnimationRate( params )
	return 0.5 
end

-------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike_end:GetActivityTranslationModifiers( params )
	return "sandking_rubyspire_burrowstrike"
end
