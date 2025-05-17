// MNetworkVarNames = "char m_pszSubquestText"
// MNetworkVarNames = "bool m_bHidden"
// MNetworkVarNames = "bool m_bCompleted"
// MNetworkVarNames = "bool m_bShowProgressBar"
// MNetworkVarNames = "int m_nProgressBarHueShift"
// MNetworkVarNames = "int m_pnTextReplaceValuesCDotaSubquestBase"
// MNetworkVarNames = "char m_pszTextReplaceString"
// MNetworkVarNames = "int m_nTextReplaceValueVersion"
class CDotaSubquestBase : public CBaseEntity
{
	// MNetworkEnable
	char[256] m_pszSubquestText;
	// MNetworkEnable
	bool m_bHidden;
	// MNetworkEnable
	bool m_bCompleted;
	// MNetworkEnable
	bool m_bShowProgressBar;
	// MNetworkEnable
	int32 m_nProgressBarHueShift;
	// MNetworkEnable
	int32[2] m_pnTextReplaceValuesCDotaSubquestBase;
	// MNetworkEnable
	char[64] m_pszTextReplaceString;
	// MNetworkEnable
	int32 m_nTextReplaceValueVersion;
	char[256] m_pszSubquestName;
};
