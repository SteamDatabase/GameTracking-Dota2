
modifier_boss_clockwerk_passive = class({})

---------------------------------------------------------------------------

function modifier_boss_clockwerk_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_passive:OnCreated( kv )
	--self.search_radius = self:GetAbility():GetSpecialValueFor( "search_radius" )

	if IsServer() then
	end
end

--------------------------------------------------------------------------------

--[[
function modifier_boss_clockwerk_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local hCurrentEncounter = GameRules.Aghanim:GetCurrentRoom():GetEncounter()
			if hCurrentEncounter.bClockwerkDead == false then
				hCurrentEncounter:SetClockwerkDead()
			end

			local allies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(),
				self:GetParent(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false
			)

			for _, ally in pairs( allies ) do
				if ally ~= nil and ally:GetUnitName() == "npc_dota_boss_tinker" then
					ally.AI:OnBuddyDied()
					break
				end
			end
		end
	end

	return 0
end
]]

--------------------------------------------------------------------------------
