
modifier_storegga_arm_slam = class ({})

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:OnCreated( kv )
	if IsServer() then
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.bAttackBegin = false
		self.hHitTargets = {}
		self:StartIntervalThink( kv["initial_delay"] / 2 )
	end
	
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:OnIntervalThink()
	if IsServer() then
		if self.bAttackBegin == false then
			self.bAttackBegin = true
			return
		end
		local attach1 = self:GetParent():ScriptLookupAttachment( "attach_attack1" )
		local attach2 = self:GetParent():ScriptLookupAttachment( "attach_attack1_2" )

		local vLocation1 = self:GetParent():GetAttachmentOrigin( attach1 )
		vLocation1 = GetGroundPosition( vLocation1, self:GetParent() )
		local vLocation2 = self:GetParent():GetAttachmentOrigin( attach2 )
		vLocation2 = GetGroundPosition( vLocation2, self:GetParent() )
		local Locations = {}
		table.insert( Locations, vLocation1 )
		table.insert( Locations, vLocation2 )

		for _,vPos in pairs ( Locations ) do
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.damage_radius, self.damage_radius, self.damage_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vPos, self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					self:AddHitTarget( enemy )
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
					else
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
					end
				end
			end

			local hTiny = CreateUnitByName( "npc_dota_creature_small_storegga", vPos, true, self:GetParent(), self:GetParent():GetOwner(), self:GetParent():GetTeamNumber() )
			if hTiny ~= nil then
				hTiny:SetControllableByPlayer( self:GetParent():GetPlayerOwnerID(), false )
				hTiny:SetOwner( self:GetParent() )
				hTiny.bBossMinion = true
				if self:GetParent().Encounter then
					self:GetParent().Encounter:SuppressRewardsOnDeath( hTiny )
				end
			end
		end

		EmitSoundOnLocationWithCaster( vLocation1, "OgreTank.GroundSmash", self:GetCaster() )
		self:StartIntervalThink( -1 )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:GetModifierDisableTurning( params )
	if IsServer() then
		if self.bAttackBegin == true then
			return 1
		end
	end

	return 0
end

-------------------------------------------------------------------------------

function modifier_storegga_arm_slam:GetModifierTurnRate_Percentage( params )
	return -99
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end
