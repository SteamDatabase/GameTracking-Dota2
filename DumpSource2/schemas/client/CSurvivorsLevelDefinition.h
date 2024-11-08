class CSurvivorsLevelDefinition
{
	SurvivorsLevelID_t m_unLevelID;
	CUtlVector< CSurvivorsEnemyEventDefinition > m_vecEvents;
	CUtlVector< CSurvivorsEnemyEventDefinition > m_vecBossEvents;
	Vector2D m_vMapBounds;
	Vector2D m_vEntityBounds;
};
