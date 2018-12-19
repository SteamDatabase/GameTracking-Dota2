modifier_creature_doomling_infernal_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_doomling_infernal_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_doomling_infernal_passive:IsHidden()
	return false;
end

--------------------------------------------------------------------------------
function modifier_creature_doomling_infernal_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_creature_doomling_infernal_passive:OnCreated( kv )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------
function modifier_creature_doomling_infernal_passive:OnAttackLanded( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker
		
		if hTarget == nil or hTarget:IsBuilding() then
			return 0
		end

		if hAttacker == self:GetParent() then

			local nLevel = self:GetParent():GetLevel()-1
			self.ministun_duration = self:GetAbility():GetLevelSpecialValueFor( "ministun_duration", nLevel )
			self.burn_duration = self:GetAbility():GetLevelSpecialValueFor( "burn_duration", nLevel )
			self.proc_chance = self:GetAbility():GetLevelSpecialValueFor( "proc_chance", nLevel )

			--printf("ability level is %s with proc chance %s", self:GetAbility():GetLevel(), self.proc_chance )
			if RandomFloat(0, 1) <= self.proc_chance then
				-- be nice and don't chain stun you
				if hTarget:FindModifierByName("modifier_bashed") == nil then
					hTarget:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_bashed", { duration=self.ministun_duration} )
					local kv2 = { duration=self.burn_duration }
					hTarget:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_doom_bringer_infernal_blade_burn", kv2)
					ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget ) )
					EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", hTarget )
				end
			end
		end
	end

	return 0
end