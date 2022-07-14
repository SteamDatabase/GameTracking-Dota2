creature_shadow_wave = class({})

--------------------------------------------------------------------------------

function creature_shadow_wave:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 75, 75, 75 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 230, 100, 223 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function creature_shadow_wave:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end
--------------------------------------------------------------------------------

function creature_shadow_wave:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		local hTarget = self:GetCursorTarget()
		if hTarget ~= nil then
			self.bounce_radius = self:GetSpecialValueFor( "bounce_radius" )
			self.damage_radius = self:GetSpecialValueFor( "damage_radius" )
			self.damage = self:GetSpecialValueFor( "damage" )
			self.max_targets = self:GetSpecialValueFor( "max_targets" )

			self.nCurJumpCount = 1
			self.hHitEntities = {}

			local nFXIndex  = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.damage_radius, 0, 0 ) )
			ParticleManager:SetParticleControlEnt( nFXIndex, 3, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self.vTargetLoc = self:GetCaster():GetOrigin()
	
			self:DoHealAndDamage( self:GetCaster() )
			table.insert( self.hHitEntities, self:GetCaster() )

			EmitSoundOn( "Hero_Dazzle.Shadow_Wave", self:GetCaster() )

			local nFXIndex2  = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetCaster():GetOrigin() )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( self.damage_radius, 0, 0 ) )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex2 )

			self.vTargetLoc = hTarget:GetOrigin()
			if self:GetCaster() ~= hTarget then
				self:DoHealAndDamage( hTarget )

				local nFXIndex3  = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
				ParticleManager:SetParticleControl( nFXIndex3, 0, self.vTargetLoc )
				ParticleManager:SetParticleControlEnt( nFXIndex3, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex3, 2, Vector( self.damage_radius, 0, 0 ) )
				ParticleManager:SetParticleControlEnt( nFXIndex3, 3, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex3 )

				self.vTargetLoc = hTarget:GetOrigin()
				table.insert( self.hHitEntities, hTarget )
			else
				self.nCurJumpCount = self.nCurJumpCount - 1
			end

			while self.nCurJumpCount < self.max_targets do
				local hBestJumpTarget = nil

				local friendlies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vTargetLoc, self:GetCaster(), self.bounce_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				for _,friendly in pairs(friendlies) do
					if friendly ~= nil then
						hBestJumpTarget = friendly
					end
				end

				if hBestJumpTarget ~= nil then

					self:DoHealAndDamage( hBestJumpTarget )

					local nFXIndex4  = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, hBestJumpTarget )
					ParticleManager:SetParticleControl( nFXIndex4, 0, self.vTargetLoc )
					ParticleManager:SetParticleControlEnt( nFXIndex4, 1, hBestJumpTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hBestJumpTarget:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex4, 2, Vector( self.damage_radius, 0, 0 ) )
					ParticleManager:SetParticleControlEnt( nFXIndex4, 3, hBestJumpTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hBestJumpTarget:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex4 )

					self.vTargetLoc = hBestJumpTarget:GetOrigin()
					table.insert( self.hHitEntities, hTarget )
				end
				self.nCurJumpCount = self.nCurJumpCount + 1
			end
		end
	end
end

--------------------------------------------------------------------------------

function creature_shadow_wave:DoHealAndDamage( hTarget )
	if IsServer() then
		hTarget:Heal( self.damage, self )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and enemy:IsNull() == false then
					local damage = 
					{
						victim = enemy,
						attacker = self:GetCaster(), 
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
						ability = self
					}
					ApplyDamage( damage )
					local vDir = enemy:GetOrigin() - hTarget:GetOrigin()
					local nFXIndex  = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf", PATTACH_CUSTOMORIGIN, enemy )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, vDir )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
		end
	end
end