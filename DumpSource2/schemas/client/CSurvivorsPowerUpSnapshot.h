// MGetKV3ClassDefaults = {
//	"m_unPowerUpID": 0,
//	"m_vecUpgradeIDs":
//	[
//	],
//	"m_bShardUpgraded": false,
//	"m_bScepterUpgraded": false
//}
// MVDataRoot
class CSurvivorsPowerUpSnapshot
{
	SurvivorsPowerUpID_t m_unPowerUpID;
	CUtlVector< SurvivorsUpgradeID_t > m_vecUpgradeIDs;
	bool m_bShardUpgraded;
	bool m_bScepterUpgraded;
};
