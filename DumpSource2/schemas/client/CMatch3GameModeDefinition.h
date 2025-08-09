// MGetKV3ClassDefaults = {
//	"m_unGameModeID": 0,
//	"m_sLocName": "",
//	"m_sOpponentScene": "",
//	"m_sBackgroundImage": "",
//	"m_nBoardRows": 0,
//	"m_nBoardCols": 0,
//	"m_flPlayerHealth": 100.000000,
//	"m_vecHeroes":
//	[
//	],
//	"m_vecLevels":
//	[
//	]
//}
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
