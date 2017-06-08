modifier_sand_king_tail_swipe = class ({})

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:OnCreated( kv )
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_tail", self:GetCaster():GetOrigin(), true )
		
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )


		self.hHitTargets = {}

		self:StartIntervalThink( kv["initial_delay"] )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:OnIntervalThink()
	if IsServer() then
		local tail1 = self:GetParent():ScriptLookupAttachment( "attach_tail" )
		local tail2 = self:GetParent():ScriptLookupAttachment( "attach_tail2" )
		local tail3 = self:GetParent():ScriptLookupAttachment( "attach_tail3" )
		local tail4 = self:GetParent():ScriptLookupAttachment( "attach_tail4" )
		local vLocation1 = self:GetParent():GetAttachmentOrigin( tail1 )
		local vLocation2 = self:GetParent():GetAttachmentOrigin( tail2 )
		local vLocation3 = self:GetParent():GetAttachmentOrigin( tail3 )
		local vLocation4 = self:GetParent():GetAttachmentOrigin( tail4 )
		local Locations = {}
		table.insert( Locations, vLocation1 )
		table.insert( Locations, vLocation2 )
		table.insert( Locations, vLocation3 )
		table.insert( Locations, vLocation4 )
			
		if self:GetParent():FindModifierByName( "modifier_sand_king_boss_burrow" ) ~= nil then
			for _,vPos in pairs ( Locations ) do
				local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
				ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.damage_radius, self.damage_radius, self.damage_radius ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vPos, self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
						self:AddHitTarget( enemy )
						
						local passive = self:GetCaster():FindAbilityByName( "sand_king_boss_passive" )
						local caustic_duration = passive:GetSpecialValueFor( "caustic_duration" )
						local hCausticBuff = enemy:FindModifierByName( "modifier_sand_king_boss_caustic_finale" )
						if hCausticBuff == nil then
							hCausticBuff = enemy:AddNewModifier( self:GetCaster(), passive, "modifier_sand_king_boss_caustic_finale", { duration = caustic_duration } )
							hCausticBuff:SetStackCount( 0 )
						end
						hCausticBuff:SetStackCount( hCausticBuff:GetStackCount() + 1 )  
						hCausticBuff:SetDuration( caustic_duration, true )

						local damageInfo = 
						{
							victim = enemy,
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self,
						}

						ApplyDamage( damageInfo )
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.slow_duration } )
					end
				end
			end

			EmitSoundOnLocationWithCaster( vLocation4, "OgreTank.GroundSmash", self:GetCaster() )
			self:StartIntervalThink( -1 )
		else
			self:StartIntervalThink( 0.01 )
			for _,vPos in pairs( Locations ) do
				--DebugDrawCircle( vPos, Vector( 0, 255, 0 ), 255, self.damage_radius, false, 1.0 )
				local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vPos, self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
						self:AddHitTarget( enemy )

						local passive = self:GetCaster():FindAbilityByName( "sand_king_boss_passive" )
						local caustic_duration = passive:GetSpecialValueFor( "caustic_duration" )
						local hCausticBuff = enemy:FindModifierByName( "modifier_sand_king_boss_caustic_finale" )
						if hCausticBuff == nil then
							hCausticBuff = enemy:AddNewModifier( self:GetCaster(), passive, "modifier_sand_king_boss_caustic_finale", { duration = caustic_duration } )
							hCausticBuff:SetStackCount( 0 )
						end
						hCausticBuff:SetStackCount( hCausticBuff:GetStackCount() + 1 )  
						hCausticBuff:SetDuration( caustic_duration, true )

						local damageInfo = 
						{
							victim = enemy,
							attacker = self:GetParent(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
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
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.slow_duration } )
						EmitSoundOn( "DOTA_Item.Maim", enemy )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:GetModifierDisableTurning( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_tail_swipe:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end

