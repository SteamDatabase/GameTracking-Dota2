// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CShmupEventDefinition
{
	EShmupEventType m_type;
	// MPropertySuppressExpr = "m_type != k_eShmupEventType_SpawnEnemy"
	CUtlVector< CShmupEventEnemySpawn > m_vecEnemySpawns;
	// MPropertySuppressExpr = "m_type != k_eShmupEventType_SpawnEnemy"
	CUtlString m_strPathName;
	// MPropertySuppressExpr = "m_type != k_eShmupEventType_UI"
	CUtlString m_strUIEvent;
};
