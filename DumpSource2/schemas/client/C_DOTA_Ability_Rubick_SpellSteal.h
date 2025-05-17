// MNetworkVarNames = "char m_ActivityModifier"
// MNetworkVarNames = "float m_fStolenCastPoint"
class C_DOTA_Ability_Rubick_SpellSteal : public C_DOTABaseAbility
{
	// MNetworkEnable
	char[256] m_ActivityModifier;
	// MNetworkEnable
	float32 m_fStolenCastPoint;
	CHandle< C_BaseEntity > m_hStealTarget;
	CHandle< C_DOTABaseAbility > m_hStealAbility;
};
