class C_PlayerCosmeticPropClientside : public C_DynamicPropClientside
{
	int32 m_iPlayerNum;
	int32 m_iCosmeticType;
	char[4096] m_szProxyTextureName;
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hProxyTexture;
	bool m_bGeneratedShowcaseProps;
	CUtlVector< C_PlayerCosmeticPropClientside* > m_vecShowcaseProps;
	C_EconItemView* m_pShowcaseItem;
};
