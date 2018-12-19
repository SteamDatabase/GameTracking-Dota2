
modifier_invoker_bonus_ability_points = class({})

--------------------------------------------------------------------------------

function modifier_invoker_bonus_ability_points:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_invoker_bonus_ability_points:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_invoker_bonus_ability_points:OnCreated( kv )
	if IsServer() then
		print( "modifier_invoker_bonus_ability_points:OnCreated" )

		-- Buff my quas, wex, exort by 1 each (will need to add a level for relevant values in each Invoker ability)
		local hQuas = self:GetParent():FindAbilityByName( "invoker_quas" )
		local hWex = self:GetParent():FindAbilityByName( "invoker_wex" )
		local hExort = self:GetParent():FindAbilityByName( "invoker_exort" )

		if hQuas and hQuas:GetLevel() == 0 then
			hQuas:SetLevel( 1 )
		end
		if hWex and hWex:GetLevel() == 0 then
			hWex:SetLevel( 1 )
		end
		if hExort and hExort:GetLevel() == 0 then
			hExort:SetLevel( 1 )
		end
	end
end

--------------------------------------------------------------------------------
