// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_unStartNodeID": 0,
//	"m_vecBlockedNodes":
//	[
//	],
//	"m_baseAppearance":
//	{
//		"m_sImage": "",
//		"m_sClassName": "",
//		"m_vSize":
//		[
//			0.000000,
//			0.000000
//		],
//		"m_unFrameWidth": 0,
//		"m_unFrameTime": 100
//	},
//	"m_vecOverrides":
//	[
//	]
//}
// MVDataRoot
class CDOTAOverworldHero
{
	OverworldHeroID_t m_unID;
	// MPropertyDescription = "The origin node for the hero. Must be unlocked for the hero to appear, and can only path to nodes accessible from here."
	OverworldNodeID_t m_unStartNodeID;
	// MPropertyDescription = "Nodes the hero cannot pass through, even if unlocked. Allows us to have multiple heroes split up on the map"
	CUtlVector< OverworldNodeID_t > m_vecBlockedNodes;
	CDOTAOverworldCharacterBase m_baseAppearance;
	// MPropertyDescription = "The highest priority overrides go first. The first override that meets its conditions is applied."
	CUtlVector< DOTAOverworldCharacterOverrideConditional_t > m_vecOverrides;
};
