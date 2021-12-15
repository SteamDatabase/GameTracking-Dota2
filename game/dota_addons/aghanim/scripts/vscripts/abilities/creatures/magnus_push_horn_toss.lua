
magnus_push_horn_toss = class({})

----------------------------------------------------------------------------------------

function magnus_push_horn_toss:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_horn_toss.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf", context )
end

--------------------------------------------------------------------------------

function magnus_push_horn_toss:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function magnus_push_horn_toss:OnAbilityPhaseStart()
	if IsServer() then 
		if self.grab_radius == nil then 
			self.grab_radius = self:GetSpecialValueFor( "radius" )
		end

		self.skewer_range = 1100
		self.hSkewerAbility = self:GetCaster():FindAbilityByName( "creature_magnus_push_skewer" )
		if self.hSkewerAbility ~= nil then
			self.skewer_range = self.hSkewerAbility:GetSpecialValueFor("range")
			--printf('setting Skewer Range to ' .. self.skewer_range)
		end

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_absolute_no_cc", { duration = -1 } )

		--self.pull_offset = self:GetSpecialValueFor( "pull_offset" )
		--self.vTargetPos = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self.pull_offset
		self.vTargetPos = self:GetCursorPosition()

		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self.vTargetPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.grab_radius, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( 6, 0, 1 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( 255, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 4, Vector( 0, 0, 0 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function magnus_push_horn_toss:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end

--------------------------------------------------------------------------------

function magnus_push_horn_toss:OnSpellStart()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( 'modifier_absolute_no_cc' )
		ParticleManager:DestroyParticle( self.nFXIndex, true )
		EmitSoundOn( "Hero_Magnataur.HornToss.Cast", self:GetCaster() )
		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_5 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_magnataur/magnataur_horn_toss.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_horn", self:GetCaster():GetAbsOrigin(),true)
		ParticleManager:ReleaseParticleIndex( nFXIndex )


		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vTargetPos, nil, self.grab_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then

				local toss_damage = self:GetSpecialValueFor( "damage" )
				local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = toss_damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

				ApplyDamage( damageInfo )
				local myBackward = self:GetCaster():GetForwardVector() * (-1)
				local destination_offset = self:GetSpecialValueFor( "destination_offset" )
				local vDestination = self:GetCaster():GetAbsOrigin() + myBackward * destination_offset



				local urns = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.skewer_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_FARTHEST, false )

				--check that there's an urn somewhere
				for _,urn in pairs( urns ) do
					if urn:GetUnitName() == "npc_dota_creature_pull_urn" then
						local urnVec = urn:GetOrigin() - self:GetCaster():GetOrigin()
						local flDistance = urnVec:Length()
						urnVec = urnVec:Normalized()

						--This checks if the urn is behind Magnus. Disabling for now
						--
						--local myBackward = self:GetCaster():GetForwardVector() * (-1)
						--local flDirectionDot = DotProduct( urnVec, myBackward )
						--local flAngle = 180 * math.acos( flDirectionDot ) / math.pi
						--if flAngle < 90 then
							
						vDestination = self:GetCaster():GetAbsOrigin() + destination_offset * urnVec
						if flDistance >= 250 then
							ExecuteOrderFromTable({
								UnitIndex = self:GetCaster():entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
								AbilityIndex = self.hSkewerAbility:entindex(),
								Position = urn:GetOrigin(),
								Queue = true,
							})
						end
					break
					end
					printf("NO VALID URNS FOUND in range " .. self.skewer_range)
				end
				
				local kv = 
				{
					x = vDestination.x,
					y = vDestination.y,
					z = vDestination.z,
				}
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_magnataur_horn_toss", kv )
			end
		end
	end
end

