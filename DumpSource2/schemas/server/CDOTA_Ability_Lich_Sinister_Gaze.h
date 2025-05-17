// MNetworkVarNames = "float m_flLongestGazeDuration"
class CDOTA_Ability_Lich_Sinister_Gaze : public CDOTABaseAbility
{
	// MNetworkEnable
	float32 m_flLongestGazeDuration;
	CUtlVector< CHandle< CBaseEntity > > m_hAffectedEntities;
};
