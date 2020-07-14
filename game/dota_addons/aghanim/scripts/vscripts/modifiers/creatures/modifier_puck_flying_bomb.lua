
modifier_puck_flying_bomb = class({})

-------------------------------------------------------------------

function modifier_puck_flying_bomb:IsHidden()
	return true
end

-------------------------------------------------------------------

function modifier_puck_flying_bomb:IsPurgable()
	return false
end

-------------------------------------------------------------------

function modifier_puck_flying_bomb:RemoveOnDeath()
	return false
end

-------------------------------------------------------------------

function modifier_puck_flying_bomb:OnCreated( kv )
	if IsServer() then
		self.explosion_damage = self:GetAbility():GetSpecialValueFor( "explosion_damage" )
		self.flight_duration = self:GetAbility():GetSpecialValueFor( "flight_duration" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.explosion_radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" )
		self.flight_speed = self:GetAbility():GetSpecialValueFor( "flight_speed" )

		self.hBomb = CreateUnitByName( "npc_dota_beastmaster_axe", self:GetParent():GetOrigin(), false, nil, nil, self:GetParent():GetTeamNumber() )
		if self.hBomb == nil then
			self:Destroy()
			return
		end

		self.hBomb:SetBaseMoveSpeed( self.flight_speed )

		self.hBomb:AddEffects( EF_NODRAW )
		self.hBomb:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_beastmaster_axe_invulnerable", kv )

		self.vSourceLoc = self:GetCaster():GetOrigin()
		--self.vSourceLoc.z = self.vSourceLoc.z + 50
		self.vTargetLoc = Vector( kv["x"], kv["y"], self.vSourceLoc.z )
		local flGroundHeight = GetGroundHeight( self.vTargetLoc, nil )
		self.vTargetLoc.z = flGroundHeight + 50

		local nDestinationRadius = self.explosion_radius / 2
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/puck/flying_bomb_destination.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self, PATTACH_ABSORIGIN, nil, self.vTargetLoc, true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( nDestinationRadius, nDestinationRadius, nDestinationRadius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 190, 6, 215 ) )

		local vForward = self:GetCaster():GetForwardVector()
		self.hBomb:SetForwardVector( vForward )

		self.nBombFXIndex = ParticleManager:CreateParticle( "particles/creatures/puck/puck_flying_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nBombFXIndex, 0, self.hBomb, PATTACH_ABSORIGIN_FOLLOW, nil, self.hBomb:GetOrigin(), true )

		EmitSoundOn( "Puck.FlyingBomb.Flight", self.hBomb )

		self:StartIntervalThink( 0.05 )
	end
end

-------------------------------------------------------------------

function modifier_puck_flying_bomb:OnIntervalThink()
	if IsServer() then
		if not self.bIssuedMoveCommand then
			ExecuteOrderFromTable({
				UnitIndex = self.hBomb:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.vTargetLoc,
			})

			self.bIssuedMoveCommand = true
		end
	end
end

--------------------------------------------------------------------------------

function modifier_puck_flying_bomb:OnDestroy()
	if IsServer() then
		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
			self.nPreviewFX = nil
		end

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self.hBomb:GetOrigin(), self.hBomb, self.explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.explosion_damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_beastmaster/beastmaster_wildaxes_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		if self.nBombFXIndex then
			ParticleManager:DestroyParticle( self.nBombFXIndex, true )
		end

		local vDetonationPos = self.hBomb:GetAbsOrigin() + Vector( 0, 0, 100 )
		local nDetonationFX = ParticleManager:CreateParticle( "particles/creatures/puck/puck_bomb_detonation.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nDetonationFX, 0, vDetonationPos )
		ParticleManager:SetParticleControl( nDetonationFX, 1, Vector( self.explosion_radius, self.explosion_radius, self.explosion_radius ) )
		ParticleManager:ReleaseParticleIndex( nDetonationFX )

		StopSoundOn( "Puck.FlyingBomb.Flight", self.hBomb )
		EmitSoundOn( "Puck.FlyingBomb.Detonate", self.hBomb )

		UTIL_Remove( self.hBomb )
	end
end

-------------------------------------------------------------------
