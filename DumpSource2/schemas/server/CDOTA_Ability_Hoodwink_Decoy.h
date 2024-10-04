class CDOTA_Ability_Hoodwink_Decoy : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > hIllusion;
	float32 decoy_stun_duration;
	int32 decoy_detonate_radius;
	int32 projectile_speed;
	ParticleIndex_t m_nFXIndex;
}
