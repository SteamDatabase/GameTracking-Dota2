// MGetKV3ClassDefaults = {
//	"m_strImage": "",
//	"m_strImageMask": "",
//	"m_vViewStart":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_vViewEnd":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_bounds":
//	{
//		"x": 0,
//		"y": 0,
//		"w": -1,
//		"h": -1
//	},
//	"m_nAnimOffsetX": 0,
//	"m_nAnimOffsetY": 0,
//	"m_vecAnimations":
//	[
//	],
//	"m_bScale": false
//}
class CDOTACrownfallCreditsMapSceneDefinition
{
	CPanoramaImageName m_strImage;
	CPanoramaImageName m_strImageMask;
	Vector2D m_vViewStart;
	Vector2D m_vViewEnd;
	CrownfallCreditsAABB_t m_bounds;
	int32 m_nAnimOffsetX;
	int32 m_nAnimOffsetY;
	CUtlVector< CDOTACrownfallCreditsMapSceneAnimateableDefinition > m_vecAnimations;
	bool m_bScale;
};
