modifier_sand_king_claw_attack = class ({})

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:OnCreated( kv )
	if IsServer() then
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.forward_movement = self:GetAbility():GetSpecialValueFor( "forward_movement" )
		self.hHitTargets = {}

		self:StartIntervalThink( kv["initial_delay"] )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( 0.01 )
		local vForward = self:GetParent():GetForwardVector()
		self:GetParent():SetOrigin( self:GetParent():GetOrigin() + vForward * self.forward_movement ) 

		local szSequenceName = self:GetParent():GetSequence()
		local attachAttack1 = nil
		local attachAttack2 = nil
		local vLocation1 = nil
		local vLocation2 = nil
		if szSequenceName == "sand_king_attack3_anim" or szSequenceName == "sand_king_attack_anim" then
			attachAttack1 = self:GetParent():ScriptLookupAttachment( "attach_attack1" )
			vLocation1 = self:GetParent():GetAttachmentOrigin( attachAttack1 )
	
		end
		if szSequenceName == "sand_king_attack3_anim" or szSequenceName == "sand_king_attack2_anim" then
			attachAttack2 = self:GetParent():ScriptLookupAttachment( "attach_attack2" )
			vLocation2 = self:GetParent():GetAttachmentOrigin( attachAttack2 )
		end

		if attachAttack1 ~= nil then
			--DebugDrawCircle( vLocation1, Vector( 0, 255, 0 ), 255, self.damage_radius, false, 1.0 )
			local enemies1 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vLocation1, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if #enemies1 > 0 then
				for _,enemy in pairs( enemies1 ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
						self:AddHitTarget( enemy )
						local damageInfo = 
						{
							victim = enemy,
							attacker = self:GetParent(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self,
						}

						ApplyDamage( damageInfo )
						--enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_bloodseeker_rupture", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) } )
						EmitSoundOn( "DOTA_Item.Maim", enemy )
					end
				end
			end
		end
	
		if attachAttack2 ~= nil then
			--DebugDrawCircle( vLocation2, Vector( 0, 0, 255 ), 255, self.damage_radius, false, 1.0 )
			local enemies2 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vLocation2, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if #enemies2 > 0 then
				for _,enemy in pairs( enemies2 ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
						self:AddHitTarget( enemy )
						local damageInfo = 
						{
							victim = enemy,
							attacker = self:GetParent(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self,
						}

						ApplyDamage( damageInfo )
						--enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_bloodseeker_rupture", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) } )
						EmitSoundOn( "DOTA_Item.Maim", enemy )
					end
				end
			end
		end

		--DebugDrawCircle( self:GetParent():GetOrigin(), Vector( 0, 0, 255 ), 255, self.damage_radius, false, 1.0 )
		local enemies3 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies3 > 0 then
			for _,enemy in pairs( enemies3 ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
					self:AddHitTarget( enemy )
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetParent(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					--enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_bloodseeker_rupture", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) } )
					EmitSoundOn( "DOTA_Item.Maim", enemy )
				end
			end
		end

		FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:GetModifierDisableTurning( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_claw_attack:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end

