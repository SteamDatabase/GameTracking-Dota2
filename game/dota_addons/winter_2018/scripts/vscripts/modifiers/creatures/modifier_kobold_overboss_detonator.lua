
modifier_kobold_overboss_detonator = class({})

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_kobold_overboss_detonator:OnCreated( kv )
	
	self.detonator_duration = kv["duration"]
	self.search_radius = kv["radius"]
	self.max_bounces = kv["bounces"]

end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	return funcs

end

--------------------------------------------------------------------------------
function modifier_kobold_overboss_detonator:OnDestroy()
	if IsServer() then 
		local allies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false ) 
		if #allies > 1 then
			local maxHP = nil
			local target = nil
			for _,ally in pairs(allies) do
				local distanceToAlly = (self:GetParent():GetOrigin() - ally:GetOrigin()):Length()
				local HP = ally:GetHealth()
				if ally:IsAlive() and (maxHP == nil or HP > maxHP) and distanceToAlly < self.search_radius then
					maxHP = HP
					target = ally
				end
			end
			local kv = 
			{
				duration = self.detonator_duration,
				radius = self.search_radius,
				bounces = self.max_bounces
			}
			target:AddNewModifier( self:GetParent(), self, "modifier_kobold_overboss_detonator", kv )
			
			local projectile =
			{
				Target = target,
				Source = self:GetParent(),
				Ability = self,
				EffectName = "particles/units/creatures/kobold_detonator.vpcf",
				iMoveSpeed = 400,
				vSourceLoc = self:GetParent():GetOrigin(),
				bDodgeable = false,
				bProvidesVision = false,
			}

			ProjectileManager:CreateTrackingProjectile( projectile )
			EmitSoundOn( "Hero_Techies.Fireworks", self:GetParent() )

			print ("detonator passed")
		end
	end
end

function modifier_kobold_overboss_detonator:OnDeath(params)
	if IsServer() then 

		if params.unit ~= self:GetParent() then
			return
		end

--		print ("detonating")
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		EmitSoundOn( "Hero_Pudge.AttackHookImpact", self:GetParent() )
		
		local allies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false ) 
		local nMaxBounces = self.max_bounces
		local nCurrentBounces = 0
		local hLastTarget = self:GetParent()
		while #allies > 0 and nCurrentBounces < nMaxBounces do
			local hTarget = nil 
			for index, ally in pairs(allies) do
				if ally:HasModifier("modifier_kobold_overboss_detonator_thinker") == false and ally ~= self:GetParent() and ally:HasModifier("modifier_kobold_overboss_detonator") == false and ally:HasModifier("modifier_kobold_overboss_detonator_receiver") == true then
					hTarget = ally
					nCurrentBounces = nCurrentBounces + 1
					local projectile =
					{
						Target = hTarget,
						Source = hLastTarget,
						Ability = self,
						EffectName = "particles/units/heroes/hero_tinker/tinker_laser.vpcf",
						iMoveSpeed = 800,
						vSourceLoc = self:GetParent():GetOrigin(),
						bDodgeable = false,
						bProvidesVision = false,
					}
					ProjectileManager:CreateTrackingProjectile( projectile )
					hTarget:AddNewModifier( self:GetParent(), self, "modifier_kobold_overboss_detonator_thinker", {duration = nCurrentBounces / 3 + math.random() })
					--print ("detonator thinker passed, bounces = ", nCurrentBounces)

--					local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_laser.vpcf", PATTACH_ABSORIGIN_FOLLOW, NULL );
--					ParticleManager:SetParticleControlEnt( nFXIndex2, 0, hLastTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hLastTarget:GetOrigin(), true );
--					ParticleManager:SetParticleControlEnt( nFXIndex2, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
--					ParticleManager:ReleaseParticleIndex( nFXIndex2 );

					hLastTarget = hTarget

				end
				table.remove (allies, index)
				break
			end
		end
	end
end






--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator:GetModifierModelScale( params )
	return 50
end

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator:GetModifierModelChange( params )
	return "models/creeps/neutral_creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl"
end
--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_kobold_overboss_detonator:GetEffectName()
    return "particles/units/creatures/kobold_detonator_shield.vpcf"
end

function modifier_kobold_overboss_detonator:IsConsideredHero()
	return true
end

function modifier_kobold_overboss_detonator:GetModifierIncomingDamage_Percentage( params )
	return 350
end
