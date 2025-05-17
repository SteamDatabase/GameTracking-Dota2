// MNetworkVarNames = "float m_flLongestShackleDuration"
class C_DOTA_Ability_ShadowShaman_Shackles : public C_DOTABaseAbility
{
	// MNetworkEnable
	float32 m_flLongestShackleDuration;
	CUtlVector< CHandle< C_BaseEntity > > m_Victims;
};
