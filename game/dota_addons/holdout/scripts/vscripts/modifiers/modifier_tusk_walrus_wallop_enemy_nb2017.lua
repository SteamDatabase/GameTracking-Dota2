modifier_tusk_walrus_wallop_enemy_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:RemoveOnDeath()
	return false
end


--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:OnCreated( kv )
	self.knockback_speed = self:GetAbility():GetSpecialValueFor( "knockback_speed" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" ) 
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )

	local knockback_distance_bonus = 0
	local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_tusk_walrus_wallop_knockback_distance" )
	if hTalent and hTalent:GetLevel() > 0 then
		--print( 'INCREASING WALRUS WALLOP KNOCKBACK DISTANCE = ' .. hTalent:GetSpecialValueFor( "value" ) )
		knockback_distance_bonus = hTalent:GetSpecialValueFor( "value" )
	end

	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end

		local hSourceUnit = EntIndexToHScript( kv.source_ent_index )

		self.vDirection = self:GetParent():GetOrigin() - hSourceUnit:GetOrigin()
		self.vDirection = self.vDirection:Normalized()
		self.vDirection.z = 0.0
		self.flDistRemaining = ( self.knockback_distance + knockback_distance_bonus )
		if hSourceUnit ~= self:GetCaster() then
			self.flDistRemaining = self.flDistRemaining / 2
			self.knockback_speed = self.knockback_speed / 2
		end
		
	end
end


--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end


--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local flMoveDist = math.min( self.flDistRemaining, self.knockback_speed * dt )
		me:SetOrigin( me:GetOrigin() + flMoveDist * self.vDirection )

		local hBuff = self:GetCaster():FindModifierByName( "modifier_tusk_walrus_wallop_nb2017" )
		if hBuff == nil then
			return
		end

		local bHitAnEnemy = false

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), me:GetOrigin(), me, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					if hBuff:HasHitTarget( enemy ) == false and not hBuff:HasHitMaxTargets() then
						hBuff:AddHitTarget( enemy )
						
						bHitAnEnemy = true
					
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true );
						ParticleManager:SetParticleControlEnt( nFXIndex, 1, enemy, PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true );
						ParticleManager:SetParticleControlEnt( nFXIndex, 2, GetParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_hand.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
						ParticleManager:SetParticleControlEnt( nFXIndexB, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true );
						ParticleManager:SetParticleControlEnt( nFXIndexB, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
						ParticleManager:ReleaseParticleIndex( nFXIndexB )

						EmitSoundOn( "Hero_Tusk.WalrusWallop.SecondaryTarget", enemy )

						local kv =
						{
							duration = self.knockback_duration,
							source_ent_index = me:entindex()
						}

						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_tusk_walrus_punch_slow", kv )
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_tusk_walrus_wallop_enemy_nb2017", kv )
						self:GetCaster():PerformAttack( enemy, true, true, true, true, false, false, true )
					end
				end
			end
		end

		if bHitAnEnemy == true then
			self:Destroy()
		end
	end
end


--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_enemy_nb2017:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

