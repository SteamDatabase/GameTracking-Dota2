class C_DOTA_Unit_Hero_Spectre : public C_DOTA_BaseNPC_Hero
{
	uint8 m_unCurrentArcanaKillStreak;
	uint8 m_unBestArcanaKillStreak;
	PlayerID_t m_nVictimPlayerID;
	bool m_bArcanaKillstreakRecordBroken;
};
