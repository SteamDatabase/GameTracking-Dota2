// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CMatch3GameModeDefinition
{
	Match3GameModeID_t m_unGameModeID;
	CUtlString m_sLocName;
	CUtlString m_sOpponentScene;
	CPanoramaImageName m_sBackgroundImage;
	int32 m_nBoardRows;
	int32 m_nBoardCols;
	float32 m_flPlayerHealth;
	CUtlVector< CUtlString > m_vecHeroes;
	CUtlVector< CMatch3Level* > m_vecLevels;
};
