class CModelState
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	CUtlSymbolLarge m_ModelName;
	bool m_bClientClothCreationSuppressed;
	uint64 m_MeshGroupMask;
	C_NetworkUtlVectorBase< int32 > m_nBodyGroupChoices;
	int8 m_nIdealMotionType;
	int8 m_nForceLOD;
	int8 m_nClothUpdateFlags;
};
