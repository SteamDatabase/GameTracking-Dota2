bomb_squad_stasis_launch = class({})
LinkLuaModifier( "modifier_bomb_squad_stasis_trap", "modifiers/creatures/modifier_bomb_squad_stasis_trap", LUA_MODIFIER_MOTION_NONE ) 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function bomb_squad_stasis_launch:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", context )
	PrecacheResource("model", "models/heroes/techies/fx_techiesfx_stasis.vmdl", context)
end





function bomb_squad_stasis_launch:OnSpellStart()
	if IsServer() then
		
		self.vTarget = self:GetCursorPosition()
		local hMine = CreateUnitByName( "npc_aghsfort_creature_bomb_squad_stasis_trap", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		hMine:AddNewModifier( self:GetCaster(), self, "modifier_bomb_squad_stasis_trap", { duration = self:GetSpecialValueFor( "mine_lifetime" ) } )


		hMine:SetDeathXP( 0 )
		hMine:SetMinimumGoldBounty( 0 )
		hMine:SetMaximumGoldBounty( 0 )

		local kv =
		{
			vLocX = self.vTarget.x,
			vLocY = self.vTarget.y,
			vLocZ = self.vTarget.z,
		}
		hMine:SetAbsAngles( 0 , self.vTarget.y, 0 )
		hMine:AddNewModifier( self:GetCaster(), self, "modifier_frostivus2018_broodbaby_launch", kv )

	end
end
