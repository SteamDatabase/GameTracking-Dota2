aghsfort_brewmaster_primal_split = class({})
LinkLuaModifier( "modifier_brewmaster_split", "modifiers/creatures/modifier_brewmaster_split", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghsfort_brewmaster_primal_split:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_brewmaster_earth_unit", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_brewmaster_storm_unit", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_brewmaster_fire_unit", context, -1 )
end

--------------------------------------------------------------------------------

function aghsfort_brewmaster_primal_split:OnAbilityPhaseStart()
	if IsServer() then
		local hLines = { "Hero_Brewmaster.PrimalSplit.VO6", "Hero_Brewmaster.PrimalSplit.VO7", "Hero_Brewmaster.PrimalSplit.VO8", }
		local nRandomInt = RandomInt(1,3)
		local hSplitLine = hLines[nRandomInt]
		EmitSoundOn( hSplitLine, self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function aghsfort_brewmaster_primal_split:OnSpellStart()
	if IsServer() == false then
		return
	end
	
	EmitSoundOn( "Hero_Brewmaster.PrimalSplit.Cast", self:GetCaster() )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_brewmaster_split", { duration = self:GetSpecialValueFor( "split_duration" ) } )
end

--------------------------------------------------------------------------------