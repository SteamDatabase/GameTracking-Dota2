class CDotaQuest
{
	char[256] m_pszQuestTitle;
	char[256] m_pszQuestText;
	int32 m_nQuestType;
	CHandle< CDotaSubquestBase >[8] m_hSubquests;
	bool m_bHidden;
	bool m_bCompleted;
	bool m_bWinIfCompleted;
	bool m_bLoseIfCompleted;
	char[256] m_pszGameEndText;
	int32[4] m_pnTextReplaceValuesCDotaQuest;
	char[64] m_pszTextReplaceString;
	int32 m_nTextReplaceValueVersion;
	int32 m_nQuestCompleteFadeAlpha;
	char[256] m_pszQuestName;
};
