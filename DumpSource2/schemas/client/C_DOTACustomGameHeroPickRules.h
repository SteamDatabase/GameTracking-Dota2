class C_DOTACustomGameHeroPickRules : public C_DOTABaseCustomHeroPickRules
{
	DOTACustomHeroPickRulesPhase_t m_Phase;
	int32 m_nNumBansPerTeam;
	GameTime_t m_flEnterTime;
	int32 m_nNumHeroesPicked;
};
