
boss_clockwerk_jetpack = class({})

--LinkLuaModifier( "modifier_rattletrap_jetpack", "modifiers/creatures/modifier_rattletrap_jetpack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_clockwerk_jetpack:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_pangolier_gyroshell.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rattletrap/rattletrap_jetpack.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_clockwerk_jetpack:OnSpellStart()
	if IsServer() then
		printf( "boss_clockwerk_jetpack:OnSpellStart()" )

		local vDirection = self:GetCaster():GetForwardVector()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		local vTargetPos = self:GetCaster():GetAbsOrigin() + vDirection

		local kv =
		{
			duration = self:GetSpecialValueFor( "duration" ),
			vTargetX = vTargetPos.x,
			vTargetY = vTargetPos.y,
			vTargetZ = vTargetPos.z,
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_rattletrap_jetpack", kv )
	end

	--[[
	float duration;
	DOTA_ABILITY_RETRIEVE_VALUE( duration );

	Vector vDirection;
	GetParent()->GetVectors( &vDirection, nullptr, nullptr );
	Vector vTargetPos = GetCaster()->GetAbsOrigin() + vDirection;

	KeyValues kv( "modifier_rattletrap_jetpack" );
	kv.SetFloat( "duration", duration );
	kv.SetFloat( "vTargetX", vTargetPos.x );
	kv.SetFloat( "vTargetY", vTargetPos.y );
	kv.SetFloat( "vTargetZ", vTargetPos.z );
	GetCaster()->AddNewModifier( GetCaster(), this, "modifier_rattletrap_jetpack", &kv );
	]]
end

--------------------------------------------------------------------------------
