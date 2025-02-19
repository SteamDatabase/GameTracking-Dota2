class C_DOTA_Ability_MonkeyKing_FurArmy
{
	CHandle< C_BaseEntity > m_hThinker;
	ParticleIndex_t m_nFXIndex;
	int32 num_first_soldiers;
	int32 num_second_soldiers;
	bool m_bCreateMonkeys;
	GameTime_t m_flNextCreationTime;
	GameTime_t m_flScepterTime;
	CUtlVector< CHandle< C_BaseEntity > > m_vecSoldiers;
};
