modifier_item_amorphotic_shell = class({})

------------------------------------------------------------------------------

function modifier_item_amorphotic_shell:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_amorphotic_shell:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_amorphotic_shell:OnCreated( kv )
	self.amoeba_duration = self:GetAbility():GetSpecialValueFor( "amoeba_duration" )
	self.amoeba_chance = self:GetAbility():GetSpecialValueFor( "amoeba_chance" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
	self.bonus_agility = self:GetAbility():GetSpecialValueFor( "bonus_agility" )
end

----------------------------------------

function modifier_item_amorphotic_shell:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_amorphotic_shell:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if params.damage > 25 and RollPercentage( self.amoeba_chance ) then
				local vSpawnPos = self:GetParent():GetOrigin() + RandomVector( 75 )
				local nFXCastIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXCastIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXCastIndex, 1, vSpawnPos )
				ParticleManager:ReleaseParticleIndex( nFXCastIndex )

				local hAmoeba = CreateUnitByName( "npc_dota_creature_pet_amoeba", vSpawnPos, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
				if hAmoeba ~= nil then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPos )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 150, 150 ) )
					ParticleManager:SetParticleControlEnt( nFXIndex, 2, hAmoeba, PATTACH_POINT_FOLLOW, "attach_hitloc", hAmoeba:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				hAmoeba:AddNewModifier( self:GetParent(), self, "modifier_kill", { duration = self.amoeba_duration } )
			end	
		end
	end
	return 0
end


----------------------------------------

function modifier_item_amorphotic_shell:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end

----------------------------------------

function modifier_item_amorphotic_shell:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end

----------------------------------------

function modifier_item_amorphotic_shell:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end

