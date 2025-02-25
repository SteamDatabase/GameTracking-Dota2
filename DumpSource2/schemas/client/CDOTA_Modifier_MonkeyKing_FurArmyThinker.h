class CDOTA_Modifier_MonkeyKing_FurArmyThinker
{
	float32 m_fDuration;
	GameTime_t m_fTimeThinkerCreated;
	CUtlVector< Vector > m_vTargetPositions;
	Vector m_vInitialPos;
	float32 first_radius;
	int32 num_first_soldiers;
	float32 second_radius;
	int32 num_second_soldiers;
	ParticleIndex_t m_nRingFXIndex;
	float32 final_radius;
	float32 leadership_time_buffer;
};
