// MGetKV3ClassDefaults = {
//	"m_vecCharacters":
//	[
//	],
//	"m_scene":
//	{
//		"m_strImage": "",
//		"m_strImageMask": "",
//		"m_vViewStart":
//		[
//			0.000000,
//			0.000000
//		],
//		"m_vViewEnd":
//		[
//			0.000000,
//			0.000000
//		],
//		"m_bounds":
//		{
//			"x": 0,
//			"y": 0,
//			"w": -1,
//			"h": -1
//		},
//		"m_nAnimOffsetX": 0,
//		"m_nAnimOffsetY": 0,
//		"m_vecAnimations":
//		[
//		],
//		"m_bScale": false
//	},
//	"m_strCustomPanoramaClass": "",
//	"m_nMarginBottom": 10,
//	"m_nMarginTop": -1,
//	"m_bSpecialThanksBlock": false,
//	"m_strLocText": "",
//	"m_bJustText": false,
//	"m_nStopOffset": -1
//}
class CDOTACrownfallCreditsBlockDefinition
{
	CUtlVector< CDOTACrownfallCreditsCharacterDefinition > m_vecCharacters;
	CDOTACrownfallCreditsMapSceneDefinition m_scene;
	CUtlString m_strCustomPanoramaClass;
	int32 m_nMarginBottom;
	int32 m_nMarginTop;
	bool m_bSpecialThanksBlock;
	CUtlString m_strLocText;
	bool m_bJustText;
	int32 m_nStopOffset;
};
