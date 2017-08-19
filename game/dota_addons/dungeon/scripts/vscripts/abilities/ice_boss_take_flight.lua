ice_boss_take_flight = class({})
LinkLuaModifier( "modifier_ice_boss_take_flight", "modifiers/modifier_ice_boss_take_flight", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------

function ice_boss_take_flight:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_take_flight:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Winter_Wyvern.ArcticBurn.Cast", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ice_boss_take_flight", {} )
	end
end

-----------------------------------------------------------------------