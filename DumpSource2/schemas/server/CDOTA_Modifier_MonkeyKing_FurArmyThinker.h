class CDOTA_Modifier_MonkeyKing_FurArmyThinker : public CDOTA_Buff
{
	float32 m_fDuration;
	GameTime_t m_fTimeThinkerCreated;
	CUtlVector< Vector > m_vTargetPositions;
	Vector m_vInitialPos;
	int32 first_radius;
	int32 num_first_soldiers;
	int32 second_radius;
	int32 num_second_soldiers;
	ParticleIndex_t m_nRingFXIndex;
	int32 final_radius;
	float32 leadership_time_buffer;
	GameTime_t m_flLastTimeInsideRing;
}
