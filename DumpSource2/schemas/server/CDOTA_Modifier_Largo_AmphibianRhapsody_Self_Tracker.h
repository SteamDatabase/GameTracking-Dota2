class CDOTA_Modifier_Largo_AmphibianRhapsody_Self_Tracker : public CDOTA_Buff
{
	int32 m_nNumSuccess;
	int32 m_nNumFail;
	int32 m_nNumExpire;
	CUtlVector< int32 > m_vecSongsPlayed;
};
