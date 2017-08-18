
modifier_siltbreaker_phase_two = class({})

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_phase_two:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_phase_two:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_phase_two:GetEffectName()
	return "particles/units/heroes/siltbreaker/siltbreaker_ambient_stage2.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_phase_two:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetModelScale( 2.9 )
		self:GetCaster():SetSkin( 1 )
		
		hPassive = self:GetParent():FindAbilityByName( "siltbreaker_passive" )
		if hPassive and hPassive:GetLevel() ~= 2 then
			hPassive:SetLevel( 2 )
			print( "hPassive level is now: " .. hPassive:GetLevel() )
		end
	end
end

--------------------------------------------------------------------------------

