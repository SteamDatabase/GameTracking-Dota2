
puck_flying_bomb = class({})
LinkLuaModifier( "modifier_puck_flying_bomb", "modifiers/creatures/modifier_puck_flying_bomb", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function puck_flying_bomb:Precache( context )
	PrecacheResource( "particle", "particles/test_particle/generic_attack_charge.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/puck/puck_flying_bomb.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/puck/puck_bomb_detonation.vpcf", context )
	--PrecacheResource( "particle", "particles/test_particle/omniknight_wildaxe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_beastmaster/beastmaster_wildaxes_hit.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_beastmaster_axe", context, -1 )
end

--------------------------------------------------------------------------------

function puck_flying_bomb:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_charge.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 135, 192, 235 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )

		EmitSoundOn( "TempleGuardian.PreAttack", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function puck_flying_bomb:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )
	end 
end

--------------------------------------------------------------------------------

function puck_flying_bomb:GetPlaybackRateOverride()
	return 0.75
end

--------------------------------------------------------------------------------

function puck_flying_bomb:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		
		local vLocation = self:GetCursorPosition()

		local kv =
		{
			x = vLocation.x,
			y = vLocation.y,
			duration = self:GetSpecialValueFor( "flight_duration" ),
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_puck_flying_bomb", kv )
	end
end

--------------------------------------------------------------------------------
