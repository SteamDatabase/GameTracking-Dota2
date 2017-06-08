werewolf_howl = class({})

----------------------------------------

LinkLuaModifier( "modifier_werewolf_howl_aura", "modifiers/modifier_werewolf_howl_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_werewolf_howl_aura_effect", "modifiers/modifier_werewolf_howl_aura_effect", LUA_MODIFIER_MOTION_NONE )

----------------------------------------

function werewolf_howl:OnSpellStart()
	EmitSoundOn( "LycanBoss.Howl", self:GetCaster() )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_werewolf_howl_aura", { duration = self:GetSpecialValueFor( "duration" ) } )
end

----------------------------------------