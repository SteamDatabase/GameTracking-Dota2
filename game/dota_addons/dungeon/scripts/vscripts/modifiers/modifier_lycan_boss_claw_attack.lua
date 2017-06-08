modifier_lycan_boss_claw_attack = class ({})

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:OnCreated( kv )
	if IsServer() then
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.hHitTargets = {}
		self.flBeginAttackTime = GameRules:GetGameTime() + kv["initial_delay"]
		self.bPlayedSound = false
		self.bInit = false
		self.bShapeshift = self:GetCaster():FindModifierByName( "modifier_lycan_boss_shapeshift" ) ~= nil

		self:StartIntervalThink( 0.01 )
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:OnIntervalThink()
	if IsServer() then
		if self.bInit == false then
			self.szSequenceName = self:GetParent():GetSequence()
			self.attachAttack1 = nil
			self.attachAttack2 = nil
			self.vLocation1 = nil
			self.vLocation2 = nil
			local szParticleName = "particles/test_particle/generic_attack_crit_blur.vpcf"
			if self.bShapeshift then
				szParticleName = "particles/test_particle/generic_attack_crit_blur_shapeshift.vpcf"
			end
			if self.szSequenceName == "attack_anim" or self.szSequenceName == "attack_alt2_anim" or self.szSequenceName == "attack3_anim" or self.szSequenceName == "attack2_alt_anim"  then
				self.attachAttack1 = self:GetParent():ScriptLookupAttachment( "attach_attack1" )

				local nFXIndex = ParticleManager:CreateParticle( szParticleName, PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			if self.szSequenceName == "attack_alt1_anim" or self.szSequenceName == "attack_alt2_anim" or self.szSequenceName == "attack3_anim" or self.szSequenceName == "attack_alt_anim"  then
				self.attachAttack2 = self:GetParent():ScriptLookupAttachment( "attach_attack2" )
				local nFXIndex2 = ParticleManager:CreateParticle( szParticleName, PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex2 )
			end
			self.bInit = true
		end
	
		if GameRules:GetGameTime() < self.flBeginAttackTime then
			return
		end

		if self.bPlayedSound == false then
			EmitSoundOn( "Roshan.PreAttack", self:GetParent() )
			self.bPlayedSound = true
		end
		
		local vForward = self:GetParent():GetForwardVector()
		self:GetParent():SetOrigin( self:GetParent():GetOrigin() + vForward * 10 ) 
		if self.attachAttack1 ~= nil then
			self.vLocation1 = self:GetParent():GetAttachmentOrigin( self.attachAttack1 )
			--DebugDrawCircle( self.vLocation1, Vector( 0, 255, 0 ), 255, self.damage_radius, false, 1.0 )
			local enemies1 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self.vLocation1, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if #enemies1 > 0 then
				for _,enemy in pairs( enemies1 ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
						self:TryToHitTarget( enemy )	
					end
				end
			end
		end
	
		if self.attachAttack2 ~= nil then
			self.vLocation2 = self:GetParent():GetAttachmentOrigin( self.attachAttack2 )
			--DebugDrawCircle( self.vLocation2, Vector( 0, 0, 255 ), 255, self.damage_radius, false, 1.0 )
			local enemies2 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self.vLocation2, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if #enemies2 > 0 then
				for _,enemy in pairs( enemies2 ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
						self:TryToHitTarget( enemy )
					end
				end
			end
		end

		--DebugDrawCircle( self.vLocation2, Vector( 0, 0, 255 ), 255, self.damage_radius, false, 1.0 )
		local enemies3 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies3 > 0 then
			for _,enemy in pairs( enemies3 ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
					self:TryToHitTarget( enemy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:GetModifierDisableTurning( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:TryToHitTarget( enemy )
	local vToTarget = enemy:GetOrigin() - self:GetCaster():GetOrigin()
	vToTarget = vToTarget:Normalized()
	local flDirectionDot = DotProduct( vToTarget, self:GetCaster():GetForwardVector() )
	local flAngle = 180 * math.acos( flDirectionDot ) / math.pi
	if flAngle < 90 then
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
		enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor( "stun_duration" ) } )
		EmitSoundOn( "Roshan.Attack.Post", enemy )
	end					
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_attack:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )
	end
end
