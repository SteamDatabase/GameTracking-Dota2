ice_boss_multi_curse = class({})

---------------------------------------------------------------------

function ice_boss_multi_curse:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_multi_curse:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true  )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,enemy in pairs ( enemies ) do
			if enemy ~= nil and enemy:IsAlive() and enemy:FindModifierByName( "modifier_ice_boss_egg_curse_marker" ) ~= nil then
				local info = {
					Target = enemy,
					Source = self:GetCaster(),
					Ability = self,
					EffectName = "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf",
					iMoveSpeed = 1500,
					vSourceLoc = self:GetCaster():GetOrigin(),
					bDodgeable = false,
					bProvidesVision = false,
				}

				ProjectileManager:CreateTrackingProjectile( info )
			end
		end
	end
end

---------------------------------------------------------------------

function ice_boss_multi_curse:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:FindModifierByName( "modifier_ice_boss_egg_curse_marker" ) ~= nil then
			hTarget:RemoveModifierByName( "modifier_ice_boss_egg_curse_marker" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_winter_wyvern_winters_curse_aura", { duration = self:GetSpecialValueFor( "duration" ) } )
			EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Target", hTarget )

			local eggs = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), nil, self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
			for _, egg in pairs( eggs ) do
				if egg ~= nil and egg:IsAlive() then
					local hBuff = egg:FindModifierByName( "modifier_ice_boss_egg_passive" )
					if hBuff ~= nil and hBuff.bHatching == false then
						local ability = egg:FindAbilityByName( "ice_boss_egg_passive" )
						if ability ~= nil then
							ability:LaunchHatchProjectile( hTarget )
						end
					end
				end
			end
		end
	end
	return true
end

---------------------------------------------------------------------