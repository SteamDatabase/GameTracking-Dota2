modifier_zombie_torso_thinker = class({})

------------------------------------------------------------------

function modifier_zombie_torso_thinker:OnDestroy()
	if IsServer() then
		local hCreep = CreateUnitByName( "npc_dota_creature_berserk_zombie_torso", self:GetCaster():GetOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hCreep ~= nil then
			hCreep:SetOwner( self:GetCaster() )
			hCreep:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
			hCreep:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
			hCreep:SetDeathXP( 0 )
			hCreep:SetMinimumGoldBounty( 0 )
			hCreep:SetMaximumGoldBounty( 0 )
		end

		UTIL_Remove( self:GetParent() )
	end
end

------------------------------------------------------------------
			
