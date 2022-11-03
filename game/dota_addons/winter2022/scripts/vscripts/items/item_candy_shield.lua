if item_candy_shield == nil then
	item_candy_shield = class({})
end

--------------------------------------------------------------------------------

function item_candy_shield:Precache( context )
	PrecacheResource( "particle", "particles/candy/candy_shield.vpcf", context )
end

--------------------------------------------------------------------------------

function item_candy_shield:OnSpellStart()
	if IsServer() then
        local nRadius = self:GetSpecialValueFor( "radius" )
        local nDuration = self:GetSpecialValueFor( "duration" )

        local tNearbyHeroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, _G.WINTER2022_REWARD_HERO_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        for _,v in pairs ( tNearbyHeroes ) do
            v:AddNewModifier( self:GetCaster(), self, "modifier_candy_shield", { duration = nDuration } )
        end

        self:GetParent():EmitSound( "Item.CrimsonGuard.Cast" );

        self:SpendCharge()
	end
end

--------------------------------------------------------------------------------

function item_candy_shield:CanUnitPickUp( hUnit )
	return true;
end

--------------------------------------------------------------------------------
