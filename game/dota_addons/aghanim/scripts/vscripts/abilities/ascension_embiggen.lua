
ascension_embiggen = class({})
LinkLuaModifier( "modifier_ascension_embiggen", "modifiers/modifier_ascension_embiggen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_embiggen_display", "modifiers/modifier_ascension_embiggen_display", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_embiggen_instance", "modifiers/modifier_ascension_embiggen_instance", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_embiggen:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", context )
	PrecacheResource( "particle", "particles/ascension/ascension_armor_sapping_target.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_embiggen:Spawn()
	-- So the modifier can be seen
	if IsServer() == true then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_embiggen_display", nil )
	end
end

--------------------------------------------------------------------------------

function ascension_embiggen:OnSpellStart()
	if not IsServer() then
		return
	end

	local hTarget = self:GetCursorTarget()
	if hTarget == nil then
		return
	end

	local nSapFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nSapFX, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )-- CP0: Target
	ParticleManager:SetParticleControlEnt( nSapFX, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )-- CP1: Caster
	ParticleManager:SetParticleControlEnt( nSapFX, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )-- CP2: Caster's hand
	ParticleManager:ReleaseParticleIndex( nSapFX )

	local nSapTargetFX = ParticleManager:CreateParticle( "particles/ascension/ascension_armor_sapping_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:ReleaseParticleIndex( nSapTargetFX )

	EmitSoundOn( "Ability.Embiggen.Target", hTarget )

	local nDuration = self:GetSpecialValueFor( "duration" )

	local kv =
	{
		duration = nDuration
	}
	local hDebuff = hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ascension_embiggen_instance", kv )
	if hDebuff == nil then
		return
	end

	-- add debuff counter
	local hDebuffCounter = hTarget:FindModifierByName( "modifier_ascension_embiggen" )
	if hDebuffCounter == nil then
		hDebuffCounter = hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ascension_embiggen", nil )
	end

	if hDebuffCounter ~= nil then
		hDebuffCounter:SetDuration( nDuration, true );
		hDebuffCounter:SetStackCount( hDebuffCounter:GetStackCount() + 1 )
	end
end
