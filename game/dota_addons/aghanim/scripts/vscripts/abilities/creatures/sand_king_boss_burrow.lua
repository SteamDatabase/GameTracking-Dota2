
sand_king_boss_burrow = class({})
LinkLuaModifier( "modifier_sand_king_boss_burrow", "modifiers/creatures/modifier_sand_king_boss_burrow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------

function sand_king_boss_burrow:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_healing_burrower", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_big_exploding_burrower", context, -1 )

end

--------------------------------------------------------------------

function sand_king_boss_burrow:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_NyxAssassin.Burrow.In", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControlForward( nFXIndex, 0, self:GetCaster():GetForwardVector() )
	end
	return true
end

--------------------------------------------------------------------------------

function sand_king_boss_burrow:GetPlaybackRateOverride()
	return 0.75
end

--------------------------------------------------------------------

function sand_king_boss_burrow:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sand_king_boss_burrow", {} )
		self:GetCaster().nBurrowFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( self:GetCaster().nBurrowFXIndex, 0, self:GetCaster():GetOrigin() )
	end
end
