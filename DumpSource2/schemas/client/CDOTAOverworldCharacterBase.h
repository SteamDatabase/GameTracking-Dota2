// MGetKV3ClassDefaults = {
//	"m_sImage": "",
//	"m_sClassName": "",
//	"m_vSize":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_vOffset":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_unFrameWidth": 0,
//	"m_unFrameTime": 100,
//	"bUse3dPreview": false,
//	"m_nPreviewHeroID": 0
//}
// MVDataRoot
class CDOTAOverworldCharacterBase
{
	CPanoramaImageName m_sImage;
	CUtlString m_sClassName;
	Vector2D m_vSize;
	Vector2D m_vOffset;
	uint16 m_unFrameWidth;
	uint16 m_unFrameTime;
	bool bUse3dPreview;
	HeroID_t m_nPreviewHeroID;
};
