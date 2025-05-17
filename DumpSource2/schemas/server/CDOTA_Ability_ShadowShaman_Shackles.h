// MNetworkVarNames = "float m_flLongestShackleDuration"
class CDOTA_Ability_ShadowShaman_Shackles : public CDOTABaseAbility
{
	// MNetworkEnable
	float32 m_flLongestShackleDuration;
	CUtlVector< CHandle< CBaseEntity > > m_Victims;
};
