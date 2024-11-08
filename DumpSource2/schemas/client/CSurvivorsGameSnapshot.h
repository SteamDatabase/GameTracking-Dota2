class CSurvivorsGameSnapshot
{
	SurvivorsGameModeID_t m_gameModeID;
	CSurvivorsPlayerSnapshot m_playerSnapshot;
	CUtlVector< CSurvivorsEnemySnapshot > m_enemiesSnapshot;
	CUtlVector< CSurvivorsPickupSnapshot > m_pickupsSnapshot;
	float32 m_flGameTime;
	int32 m_nCurrentLevelEvent;
};
