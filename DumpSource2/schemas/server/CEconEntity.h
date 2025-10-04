// MNetworkVarNames = "CAttributeContainer m_AttributeManager"
class CEconEntity : public CBaseFlex, public IHasAttributes
{
	// MNetworkEnable
	CAttributeContainer m_AttributeManager;
	CHandle< CBaseEntity > m_hOldProvidee;
	int32 m_iOldOwnerClass;
};
