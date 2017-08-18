
ice_breath = class({})

--------------------------------------------------------------------------------

function ice_breath:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		--self.duration = self:GetSpecialValueFor( "duration" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 26, 150, 255 ) )

		--EmitSoundOn( "Burrower.PreSuicide", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function ice_breath:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function ice_breath:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		
		self.rotation_angle = self:GetSpecialValueFor( "rotation_angle" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.speed = self:GetSpecialValueFor( "speed" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.projectile_count = self:GetSpecialValueFor( "projectile_count" )

		self.fChannelStartTime = GameRules:GetGameTime()

		--self.vCastAngles = self:GetCaster():GetAnglesAsVector()

		--self.vFwdVector = self:GetCaster():GetForwardVector()
		self.vRightVector = self:GetCaster():GetRightVector()

		EmitSoundOn( "Lycan.RuptureBall", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ice_breath:OnChannelThink( fInterval )
	if IsServer() then
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		--[[
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		]]

		local fClampedVal = RemapValClamped( GameRules:GetGameTime(), self.fChannelStartTime, self.fChannelStartTime + self:GetChannelTime(), 0.0, 1.0  )
		--print( "fClampedVal: " .. fClampedVal )

		--local vDirection = VectorLerp( fClampedVal, -self.vRightVector, self.vRightVector )
		local vDirAdjust = self.vRightVector * fClampedVal * 5
		local vDirection = -self.vRightVector + vDirAdjust
		--vDirection = vDirection:Normalized()

		local vVel = vDirection * self.speed

		print( "-----" )
		print( string.format( "-self.vRightVector: %f, %f, %f", -self.vRightVector.x, -self.vRightVector.y, -self.vRightVector.z ) )
		--print( string.format( "self.vRightVector: %f, %f, %f", self.vRightVector.x, self.vRightVector.y, self.vRightVector.z ) )
		print( string.format( "vDirAdjust: %f, %f, %f", vDirAdjust.x, vDirAdjust.y, vDirAdjust.z ) )
		print( string.format( "vDirection: %f, %f, %f", vDirection.x, vDirection.y, vDirection.z ) )
		print( string.format( "vVel: %f, %f, %f", vVel.x, vVel.y, vVel.z ) )

		local info = {
			EffectName = "particles/neutral_fx/mini_rosh_fire.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.radius,
			fEndRadius = self.radius,
			vVelocity = vDirection * self.speed,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), nil ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		ProjectileManager:CreateLinearProjectile( info )
	end
end

--------------------------------------------------------------------------------

function ice_breath:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget and hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self
			}
			ApplyDamage( damage )
		end
	end

	return false
end

--------------------------------------------------------------------------------


--[[
//-----------------------------------------------------------------------------
// Ability: Fire Breath
//-----------------------------------------------------------------------------
#ifdef CLIENT_DLL
#define CDOTA_Ability_Creature_Fire_Breath C_DOTA_Ability_Creature_Fire_Breath
#endif
schema class CDOTA_Ability_Creature_Fire_Breath : public CDOTABaseAbility
{
	DECLARE_ENTITY_CLASS( CDOTA_Ability_Creature_Fire_Breath, CDOTABaseAbility, "creature_fire_breath" );
public:
	
	void OnSpellStart( void ) OVERRIDE;

	bool OnProjectileHit( EHANDLE hTarget, const Vector &vLocation ) OVERRIDE;

#ifdef SERVER_DLL
	virtual void OnChannelThink( float flInterfClampedVal ) OVERRIDE;
#endif

public:

	int speed;
	int projectile_count;
	float rotation_angle;
	float damage;
	float radius;
	CountdownTimer ctTimer;
	Vector m_vecStartRot;
	Vector m_vecEndRot;
};


LINK_ENTITY_TO_CLASS( creature_fire_breath, CDOTA_Ability_Creature_Fire_Breath );


//-----------------------------------------------------------------------------

void CDOTA_Ability_Creature_Fire_Breath::OnSpellStart( void )
{
#ifdef SERVER_DLL
	DOTA_ABILITY_RETRIEVE_VALUE( rotation_angle );
	DOTA_ABILITY_RETRIEVE_VALUE( radius );
	DOTA_ABILITY_RETRIEVE_VALUE( speed );
	DOTA_ABILITY_RETRIEVE_VALUE( damage );
	DOTA_ABILITY_RETRIEVE_VALUE( projectile_count );

	QAngle angles = GetCaster()->GetAbsAngles();
	Vector vecFwd;
	AngleVectors( angles, &vecFwd );
	matrix3x4_t matRot;
	Vector vecRotAxis = Vector ( 0, 0, 1 );
	MatrixBuildRotationAboutAxis ( vecRotAxis, -rotation_angle/2, matRot );
	VectorRotate( vecFwd, matRot, m_vecStartRot );
	MatrixBuildRotationAboutAxis ( vecRotAxis, rotation_angle/2, matRot );
	VectorRotate( vecFwd, matRot, m_vecEndRot );

	float flTiming = GetChannelTime() / float( projectile_count );
	ctTimer.Start( flTiming );

	DOTA_EmitSound( DOTA_EMIT_SOUND_FLAGS_NEARBY | DOTA_EMIT_SOUND_FLAGS_VISIBLE, "Creature.FireBreath.Cast", GetCaster() );
#endif
}

//-----------------------------------------------------------------------------
#ifdef SERVER_DLL
void CDOTA_Ability_Creature_Fire_Breath::OnChannelThink( float flInterfClampedVal )
{
	BaseClass::OnChannelThink( flInterfClampedVal );
	if ( !ctTimer.IsElapsed() )
		return;

	ctTimer.Reset();

	Vector vDirection = VectorLerp( m_vecStartRot, m_vecEndRot, RemapValClamped( GetGameTime(), GetChannelStartTime(),  GetChannelStartTime() + GetChannelTime(), 0.0f, 1.0f  ));

	VectorNormalize( vDirection );

	sLinearProjectileCreateInfo info;
	info.pszEffectName = "particles/neutral_fx/mini_rosh_fire.vpcf";
	info.bStickyFoWReveal = true;
	info.pAbility = this;
	info.vVelocity = vDirection * speed;
	info.vSpawnOrigin = GetCaster()->GetAbsOrigin();
	info.fDistance = GetCastRange();
	info.fStartRadius = radius;
	info.fEndRadius = radius;
	info.hSource = GetCaster();
	info.iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY;
	info.iUnitTargetType = DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC;
	info.iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES;
	info.iVisionTeamNumber = GetCaster()->GetTeamNumber();

	g_DOTAProjectileManager.CreateLinearProjectile( info );

}
#endif


//-----------------------------------------------------------------------------

bool CDOTA_Ability_Creature_Fire_Breath::OnProjectileHit( EHANDLE hTarget, const Vector &vLocation )
{
#ifdef SERVER_DLL
	CDOTA_BaseNPC *pTarget = ToDOTABaseNPC( hTarget );
	if ( pTarget && !pTarget->IsInvulnerable() && !pTarget->IsAncient() )
	{
		ApplyDamage( GetCaster(), pTarget, this, damage, DAMAGE_TYPE_MAGICAL );
	}
#endif

	return false;
}
]]

