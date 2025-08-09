// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_szSnippet": "",
//	"m_szUnit": "",
//	"m_szModel": "",
//	"m_szParticle": "",
//	"m_eType": "k_eSprite",
//	"m_vAngles":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_vPosition":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_vCameraOffset":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_nWidth": 32,
//	"m_nHeight": 32,
//	"m_bPlayEndcap": true,
//	"m_flDefaultScale": -1.000000
//}
// MVDataRoot
class ArtyGraphicInfo_t
{
	ArtyGraphicID_t m_unID;
	CUtlString m_szSnippet;
	CUtlString m_szUnit;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_szModel;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_szParticle;
	EArtyGraphicsType m_eType;
	QAngle m_vAngles;
	Vector m_vPosition;
	Vector m_vCameraOffset;
	int32 m_nWidth;
	int32 m_nHeight;
	bool m_bPlayEndcap;
	float32 m_flDefaultScale;
};
