class CDOTA_Ability_Rubick_SpellSteal
{
	char[256] m_ActivityModifier;
	float32 m_fStolenCastPoint;
	CHandle< CBaseEntity > m_hStealTarget;
	CHandle< CDOTABaseAbility > m_hStealAbility;
	ParticleIndex_t m_nFXIndex;
	int32 m_hProjectile;
};
