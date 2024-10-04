class CDOTA_Unit_Hero_Spectre : public CDOTA_BaseNPC_Hero
{
	bool m_bArcanaKillstreakCompleted;
	uint8 m_unCurrentArcanaKillStreak;
	uint8 m_unBestArcanaKillStreak;
	PlayerID_t m_nVictimPlayerID;
	bool m_bArcanaKillstreakRecordBroken;
};
