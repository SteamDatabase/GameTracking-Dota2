if modifier_grant_candy_shield == nil then
	modifier_grant_candy_shield = class({})
end

------------------------------------------------------------------------------

function modifier_grant_candy_shield:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_grant_candy_shield:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_grant_candy_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_grant_candy_shield:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_grant_candy_shield:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() and params.attacker ~= nil then
            local max_damage = self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("golem_damage_scalar")

            local nTeam = params.attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
            local hHeroes = FindUnitsInRadius( nTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
            for _,hHero in ipairs(hHeroes) do
				if hHero:IsRealHero() then
                	hHero:AddNewModifier( self:GetParent(), self, "modifier_candy_shield", { duration = self:GetAbility():GetSpecialValueFor( "duration" ), max_damage = max_damage } )
				end
            end
            params.attacker:EmitSound( "Item.CrimsonGuard.Cast" );
		end
	end

	return 0
end