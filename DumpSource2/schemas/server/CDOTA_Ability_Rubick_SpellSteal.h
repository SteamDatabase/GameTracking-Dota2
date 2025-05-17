// MNetworkVarNames = "char m_ActivityModifier"
// MNetworkVarNames = "float m_fStolenCastPoint"
class CDOTA_Ability_Rubick_SpellSteal : public CDOTABaseAbility
{
	// MNetworkEnable
	char[256] m_ActivityModifier;
	// MNetworkEnable
	float32 m_fStolenCastPoint;
	CHandle< CBaseEntity > m_hStealTarget;
	CHandle< CDOTABaseAbility > m_hStealAbility;
	ParticleIndex_t m_nFXIndex;
	int32 m_hProjectile;
};
