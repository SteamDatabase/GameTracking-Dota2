// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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
