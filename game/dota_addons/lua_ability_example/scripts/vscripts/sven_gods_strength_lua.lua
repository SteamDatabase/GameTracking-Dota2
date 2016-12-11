sven_gods_strength_lua = class({})
LinkLuaModifier( "modifier_sven_gods_strength_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_child_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sven_gods_strength_lua:OnSpellStart()
	local gods_strength_duration = self:GetSpecialValueFor( "gods_strength_duration" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_strength_lua", { duration = gods_strength_duration }  )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------