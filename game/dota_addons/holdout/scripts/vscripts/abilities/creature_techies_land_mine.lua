creature_techies_land_mine = class({})
LinkLuaModifier( "modifier_creature_techies_land_mine", "modifiers/modifier_creature_techies_land_mine", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_techies_land_mine:OnSpellStart()
	if IsServer() then
		local hMine = CreateUnitByName( "npc_dota_creature_techies_land_mine", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hMine ~= nil then
			hMine:AddNewModifier( self:GetCaster(), self, "modifier_creature_techies_land_mine", { fadetime = 0 } )
			hMine:SetTeam( self:GetCaster():GetTeamNumber() )
			hMine:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), true )
			local vAngles = hMine:GetAnglesAsVector()
			hMine:SetAngles( vAngles.x, 0, vAngles.z )
			EmitSoundOnLocationWithCaster( hMine:GetOrigin(), "Hero_Techies.RemoteMine.Plant", hMine )
		end
	end
end
