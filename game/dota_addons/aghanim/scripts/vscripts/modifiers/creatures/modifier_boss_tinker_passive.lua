
modifier_boss_tinker_passive = class({})

---------------------------------------------------------------------------

function modifier_boss_tinker_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_passive:OnCreated( kv )
	--self.search_radius = self:GetAbility():GetSpecialValueFor( "search_radius" )

	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_passive:OnDeath( params )
	if IsServer() then
		if params.unit and params.unit:GetUnitName() == "npc_dota_creature_keen_minion" then
			local TinkerAI = self:GetParent().AI
			for key, hMinion in pairs( TinkerAI.KeenMinions ) do
				if hMinion == params.unit then
					table.remove( TinkerAI.KeenMinions, key )
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------
