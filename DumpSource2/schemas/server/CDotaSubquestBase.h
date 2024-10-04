class CDotaSubquestBase : public CBaseEntity
{
	char[256] m_pszSubquestText;
	bool m_bHidden;
	bool m_bCompleted;
	bool m_bShowProgressBar;
	int32 m_nProgressBarHueShift;
	int32[2] m_pnTextReplaceValuesCDotaSubquestBase;
	char[64] m_pszTextReplaceString;
	int32 m_nTextReplaceValueVersion;
	char[256] m_pszSubquestName;
}
