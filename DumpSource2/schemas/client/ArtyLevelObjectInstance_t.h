class ArtyLevelObjectInstance_t
{
	CUtlString m_szLeftBorderObject;
	float32 m_flLeftObjectOffset;
	CUtlString m_szRightBorderObject;
	float32 m_flRightObjectOffset;
	bool m_bRandomPosition;
	bool m_bRepositionToTerrain;
	float32 m_flLeftBorderWidthMult;
	float32 m_flRightBorderWidthMult;
	float32 m_flAppearanceChance;
	EArtyTeam m_eTeam;
	float32 m_flTimeOffset;
	CUtlVector< ArtyEnemyOrder_t > m_vecCustomOrders;
};
