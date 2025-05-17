// MNetworkVarNames = "DOTACustomHeroPickRulesPhase_t m_Phase"
// MNetworkVarNames = "int32 m_nNumBansPerTeam"
// MNetworkVarNames = "GameTime_t m_flEnterTime"
class CDOTACustomGameHeroPickRules : public CDOTABaseCustomHeroPickRules
{
	// MNetworkEnable
	DOTACustomHeroPickRulesPhase_t m_Phase;
	// MNetworkEnable
	int32 m_nNumBansPerTeam;
	// MNetworkEnable
	GameTime_t m_flEnterTime;
	int32 m_nNumHeroesPicked;
};
