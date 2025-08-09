// MGetKV3ClassDefaults = {
//	"m_sName": "",
//	"m_sTemplate": "",
//	"m_sLocName": "",
//	"m_sLocDescription": "",
//	"m_sImage": "",
//	"m_eRewardStyle": "k_eOverworldEncounterRewardStyle_Invalid",
//	"m_vecRewards":
//	[
//	],
//	"m_sDefaultDialogue": "",
//	"m_kvCustomData": null,
//	"m_bRequiresNodeToBeUnlockedToClaimRewards": true,
//	"m_nLeaderboardCount": 1
//}
// MVDataRoot
class CDOTAOverworldEncounter
{
	CUtlString m_sName;
	CUtlString m_sTemplate;
	CUtlString m_sLocName;
	CUtlString m_sLocDescription;
	CPanoramaImageName m_sImage;
	EOverworldEncounterRewardStyle m_eRewardStyle;
	CUtlVector< CDOTAOverworldEncounterReward > m_vecRewards;
	CUtlString m_sDefaultDialogue;
	KeyValues3 m_kvCustomData;
	bool m_bRequiresNodeToBeUnlockedToClaimRewards;
	int32 m_nLeaderboardCount;
};
