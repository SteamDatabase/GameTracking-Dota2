class CDOTA_Modifier_QueenOfPain_Arcana : public CDOTA_Buff
{
	CUtlOrderedMap< PlayerID_t, bool > m_vecHitPlayers;
	CUtlOrderedMap< PlayerID_t, bool > m_vecKilledPlayers;
	GameTime_t m_flLastSonicWaveCast;
	bool m_bSpeechComplete;
	bool m_bMessageComplete;
	bool m_bIsMeleeAttack;
};
