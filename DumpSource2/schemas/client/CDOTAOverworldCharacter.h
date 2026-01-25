// MGetKV3ClassDefaults = {
//	"m_appearance":
//	{
//		"m_sImage": "",
//		"m_sClassName": "",
//		"m_vSize":
//		[
//			0.000000,
//			0.000000
//		],
//		"m_vOffset":
//		[
//			0.000000,
//			0.000000
//		],
//		"m_unFrameWidth": 0,
//		"m_unFrameTime": 100,
//		"bUse3dPreview": false,
//		"m_nPreviewHeroID": 0
//	},
//	"m_conditions":
//	{
//		"m_eConditionFlags": "CompleteNode|ActiveNode",
//		"m_vecNodes":
//		[
//		]
//	},
//	"m_unHeroPartyID": 0,
//	"m_partyConditions":
//	{
//		"m_eConditionFlags": "CompleteNode|ActiveNode",
//		"m_vecNodes":
//		[
//		]
//	}
//}
// MVDataRoot
class CDOTAOverworldCharacter
{
	// MPropertyDescription = "If set, character will appear behind the specified hero in a traveling party, as long as 1 node meets the conditionals."
	CDOTAOverworldCharacterBase m_appearance;
	CDOTAOverworldCharacterConditional m_conditions;
	OverworldHeroID_t m_unHeroPartyID;
	CDOTAOverworldCharacterConditional m_partyConditions;
};
