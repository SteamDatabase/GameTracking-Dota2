// MNetworkVarNames = "char m_pszQuestTitle"
// MNetworkVarNames = "char m_pszQuestText"
// MNetworkVarNames = "int m_nQuestType"
// MNetworkVarNames = "CHandle< CDotaSubquestBase > m_hSubquests"
// MNetworkVarNames = "bool m_bHidden"
// MNetworkVarNames = "bool m_bCompleted"
// MNetworkVarNames = "bool m_bWinIfCompleted"
// MNetworkVarNames = "bool m_bLoseIfCompleted"
// MNetworkVarNames = "char m_pszGameEndText"
// MNetworkVarNames = "int m_pnTextReplaceValuesCDotaQuest"
// MNetworkVarNames = "char m_pszTextReplaceString"
// MNetworkVarNames = "int m_nTextReplaceValueVersion"
class C_DotaQuest : public C_BaseEntity
{
	// MNetworkEnable
	char[256] m_pszQuestTitle;
	// MNetworkEnable
	char[256] m_pszQuestText;
	// MNetworkEnable
	int32 m_nQuestType;
	// MNetworkEnable
	CHandle< C_DotaSubquestBase >[8] m_hSubquests;
	// MNetworkEnable
	bool m_bHidden;
	// MNetworkEnable
	bool m_bCompleted;
	// MNetworkEnable
	bool m_bWinIfCompleted;
	// MNetworkEnable
	bool m_bLoseIfCompleted;
	// MNetworkEnable
	char[256] m_pszGameEndText;
	// MNetworkEnable
	int32[4] m_pnTextReplaceValuesCDotaQuest;
	// MNetworkEnable
	char[64] m_pszTextReplaceString;
	// MNetworkEnable
	int32 m_nTextReplaceValueVersion;
	bool m_bWasCompleted;
};
