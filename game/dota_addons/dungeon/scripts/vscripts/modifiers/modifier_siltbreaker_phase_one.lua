
modifier_siltbreaker_phase_one = class({})

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_phase_one:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_phase_one:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_phase_one:GetEffectName()
	return "particles/units/heroes/siltbreaker/siltbreaker_ambient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_phase_one:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetModelScale( 2.6 )

		hPassive = self:GetParent():FindAbilityByName( "siltbreaker_passive" )
		if hPassive and hPassive:GetLevel() ~= 1 then
			hPassive:SetLevel( 1 )
			print( "hPassive level is now: " .. hPassive:GetLevel() )
		end
	end
end

--------------------------------------------------------------------------------

