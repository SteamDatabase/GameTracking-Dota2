class CDOTA_Ability_Hoodwink_Decoy : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > hIllusion;
	float32 decoy_stun_duration;
	float32 decoy_detonate_radius;
	float32 projectile_speed;
	ParticleIndex_t m_nFXIndex;
};
