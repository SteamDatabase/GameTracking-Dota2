// MNetworkVarNames = "float m_flLongestGazeDuration"
class C_DOTA_Ability_Lich_Sinister_Gaze : public C_DOTABaseAbility
{
	// MNetworkEnable
	float32 m_flLongestGazeDuration;
	CUtlVector< CHandle< C_BaseEntity > > m_hAffectedEntities;
};
