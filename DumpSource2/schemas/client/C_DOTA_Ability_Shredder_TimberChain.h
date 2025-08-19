class C_DOTA_Ability_Shredder_TimberChain : public C_DOTABaseAbility
{
	int32 chain_radius;
	ParticleIndex_t m_nFXIndex;
	Vector m_vProjectileVelocity;
	Vector m_vCasterStartingLocation;
	bool m_bRetract;
};
