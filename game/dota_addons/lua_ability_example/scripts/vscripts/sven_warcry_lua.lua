sven_warcry_lua = class({})
LinkLuaModifier( "modifier_sven_warcry_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sven_warcry_lua:OnSpellStart()
	local warcry_radius = self:GetSpecialValueFor( "warcry_radius" ) 
	local warcry_duration = self:GetSpecialValueFor(  "warcry_duration" )

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), warcry_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ally:AddNewModifier( self:GetCaster(), self, "modifier_sven_warcry_lua", { duration = warcry_duration } )
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------