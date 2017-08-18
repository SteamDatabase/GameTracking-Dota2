
modifier_siltbreaker_phase_three = class({})

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_phase_three:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_phase_three:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_phase_three:GetEffectName()
	return "particles/units/heroes/siltbreaker/siltbreaker_ambient_stage3.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_phase_three:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetModelScale( 3.2 )
		self:GetCaster():SetSkin( 2 ) -- it's currently listed as material #3 in model file
		
		hPassive = self:GetParent():FindAbilityByName( "siltbreaker_passive" )
		if hPassive and hPassive:GetLevel() ~= 3 then
			hPassive:SetLevel( 3 )
			print( "hPassive level is now: " .. hPassive:GetLevel() )
		end
	end
end

--------------------------------------------------------------------------------

