class CDOTA_Ability_Rattletrap_Hookshot : public CDOTABaseAbility
{
	ParticleIndex_t m_nFXIndex;
	Vector m_vProjectileVelocity;
	bool m_bRetract;
	CHandle< CBaseEntity > m_hSourceCaster;
};
