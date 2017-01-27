modifier_zombie_torso_thinker = class({})

------------------------------------------------------------------

function modifier_zombie_torso_thinker:OnDestroy()
	if IsServer() then
		local hCreep = CreateUnitByName( "npc_dota_creature_berserk_zombie_torso", self:GetParent():GetOrigin(), true, self:GetParent(), self:GetParent(), self:GetCaster():GetTeamNumber() )
		if hCreep ~= nil then
			hCreep:SetOwner( self:GetParent() )
			hCreep:SetControllableByPlayer( self:GetParent():GetPlayerOwnerID(), false )
			hCreep:SetInitialGoalEntity( self:GetParent():GetInitialGoalEntity() )
			hCreep:SetDeathXP( 0 )
			hCreep:SetMinimumGoldBounty( 0 )
			hCreep:SetMaximumGoldBounty( 0 )
		end
	end
end

------------------------------------------------------------------
			
