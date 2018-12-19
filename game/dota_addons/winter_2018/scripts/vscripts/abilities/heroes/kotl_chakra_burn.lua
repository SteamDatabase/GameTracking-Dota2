kotl_chakra_burn = class({})
LinkLuaModifier( "modifier_kotl_chakra_burn", "modifiers/heroes/modifier_kotl_chakra_burn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kotl_chakra_burn_debuff", "modifiers/heroes/modifier_kotl_chakra_burn_debuff", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_kotl_mana_drain_winter_effect", "modifiers/heroes/modifier_kotl_mana_drain_winter_effect", LUA_MODIFIER_MOTION_NONE )


function kotl_chakra_burn:OnSpellStart()
    local hCaster = self:GetCaster()
    local hAbility = self
    local hTarget = self:GetCursorTarget()
    self.bonus_magic_damage = self:GetSpecialValueFor("bonus_magic_damage")
    hTarget:AddNewModifier(hCaster, hAbility, "modifier_kotl_chakra_burn", {duration = self:GetSpecialValueFor( "nuke_duration" )})

    EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Cast" , hCaster)

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_keeper_of_the_light/keeper_cast02.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end
