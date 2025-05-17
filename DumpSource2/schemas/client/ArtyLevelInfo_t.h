// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class ArtyLevelInfo_t
{
	ArtyLevelID_t m_unID;
	CUtlString m_sLocLevelName;
	ArtyLevelObjectInstance_t m_playerInfo;
	CUtlVector< ArtyLevelObjectInstance_t > m_vecGameObjects;
	CUtlVector< ArtyLevelWeaponInstance_t > m_vecWeapons;
	int32 m_nLevelCompletePoints;
	int32 m_nTimeBonusBasePoints;
	int32 m_nTimeBonusMaxPoints;
	int32 m_nTimeBonusFastTime;
	int32 m_nTimeBonusMaxTime;
	float32 m_flBackgroundOffsetX;
	int32[3] m_aryStarPointThresholds;
	CPanoramaImageName m_sBackgroundImage;
	CPanoramaImageName m_sTerrainBackgroundImage;
	CPanoramaImageName m_sTerrainImage;
	CPanoramaImageName m_sTerrainForegroundImage;
};
