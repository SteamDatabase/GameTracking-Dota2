kotl_mana_leak_winter = class({})
LinkLuaModifier( "modifier_kotl_mana_leak_winter", "modifiers/heroes/modifier_kotl_mana_leak_winter", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_kotl_mana_drain_winter_effect", "modifiers/heroes/modifier_kotl_mana_drain_winter_effect", LUA_MODIFIER_MOTION_NONE )


function kotl_mana_leak_winter:OnSpellStart()
    local hCaster = self:GetCaster()
    local hAbility = self
    local hTarget = self:GetCursorTarget()
    hTarget:AddNewModifier(hCaster, hAbility, "modifier_kotl_mana_leak_winter", {duration = self:GetSpecialValueFor( "buff_duration" )})

    EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Cast" , hCaster)

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end



-- This function is just to show that you have the rupture modifier visible, but with no duration
--modifier_aoe_rupture_lua = class({})
--
--function modifier_aoe_rupture_lua:IsHidden()
--    return false
--end
--
--function modifier_aoe_rupture_lua:GetTexture()
 --   return "bloodseeker_rupture"
--end