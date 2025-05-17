// MNetworkVarNames = "float m_flLongestEnsnareDuration"
class CDOTA_Ability_Naga_Siren_Reel_In : public CDOTABaseAbility
{
	// MNetworkEnable
	float32 m_flLongestEnsnareDuration;
	CUtlVector< CHandle< CBaseEntity > > affectedEntities;
};
