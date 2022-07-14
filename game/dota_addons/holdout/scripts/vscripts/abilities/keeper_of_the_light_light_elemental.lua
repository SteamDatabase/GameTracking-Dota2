keeper_of_the_light_light_elemental = class({})
LinkLuaModifier( "modifier_keeper_of_the_light_light_elemental", "modifiers/modifier_keeper_of_the_light_light_elemental", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function keeper_of_the_light_light_elemental:OnSpellStart()	
	if IsServer() then
		local hElemental = CreateUnitByName( tostring( "npc_dota_kotl_light_spirit" .. self:GetLevel() ), self:GetCaster():GetOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hElemental ~= nil then
			hElemental:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
			FindClearSpaceForUnit( hElemental, self:GetCaster():GetOrigin(), true )

			local summon_duration = self:GetSpecialValueFor( "summon_duration" )
			hElemental:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = summon_duration } )
			hElemental:AddNewModifier( self:GetCaster(), self, "modifier_keeper_of_the_light_light_elemental", { duration = summon_duration } )
		end
	end
end

--------------------------------------------------------------------------------
