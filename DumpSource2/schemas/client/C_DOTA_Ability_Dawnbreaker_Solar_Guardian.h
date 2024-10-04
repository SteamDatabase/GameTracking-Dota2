class C_DOTA_Ability_Dawnbreaker_Solar_Guardian : public C_DOTABaseAbility
{
	CHandle< C_BaseEntity > m_hThinker;
	bool m_bJumping;
	CHandle< C_BaseEntity > m_hTeleportTarget;
	ParticleIndex_t m_nTPFXIndex;
	ParticleIndex_t m_nAoEFXIndex;
}
