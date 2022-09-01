
modifier_ogre_tank_melee_smash_thinker = class({})

-----------------------------------------------------------------------------

function modifier_ogre_tank_melee_smash_thinker:OnCreated( kv )
	if IsServer() then
		self.impact_radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

		self.bCancelled = false

		self:StartIntervalThink( 0.033 )
	end
end

-----------------------------------------------------------------------------

function modifier_ogre_tank_melee_smash_thinker:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_ogre_tank_melee_smash_thinker:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local nOrderType = params.order_type

		if hOrderedUnit == nil or hOrderedUnit ~= self:GetCaster() then
			return
		end

		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET and
			nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION and
			nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_DIRECTION and
			nOrderType ~= DOTA_UNIT_ORDER_ATTACK_TARGET and
			nOrderType ~= DOTA_UNIT_ORDER_ATTACK_MOVE and
			nOrderType ~= DOTA_UNIT_ORDER_STOP and
			nOrderType ~= DOTA_UNIT_ORDER_HOLD_POSITION and
			nOrderType ~= DOTA_UNIT_ORDER_CAST_POSITION and
			nOrderType ~= DOTA_UNIT_ORDER_CAST_NO_TARGET and
			nOrderType ~= DOTA_UNIT_ORDER_CAST_POSITION then

			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit == self:GetCaster() then
			self.bCancelled = true
			UTIL_Remove( self:GetParent() )

			return
		end
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_ogre_tank_melee_smash_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false or self:GetCaster():IsStunned() then
			--print( string.format( "Caster is nil, dead, or stunned, removing smash thinker" ) )
			UTIL_Remove( self:GetParent() )
			return -1
		end
	end
end

-----------------------------------------------------------------------------

function modifier_ogre_tank_melee_smash_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() and self.bCancelled == false then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "OgreTank.GroundSmash", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nTeamFlags = DOTA_UNIT_TARGET_TEAM_ENEMY
			if self:GetCaster():FindModifierByName( "modifier_aghsfort_winter_wyvern_winters_curse" ) then
				nTeamFlags = DOTA_UNIT_TARGET_TEAM_BOTH
			end

			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.impact_radius, nTeamFlags, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
					elseif not ( enemy:IsNull() ) and enemy ~= nil then
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
					end
				end
			end

			ScreenShake( self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )
		end

		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------

