class CDOTA_Modifier_MonkeyKing_FurArmy_SoldierInPosition
{
	Vector m_vTargetPos;
	CHandle< C_BaseEntity > m_hAttackTarget;
	float32 attack_speed;
	int32 second_radius;
	int32 outer_attack_buffer;
	CHandle< C_BaseEntity > m_hThinker;
	bool m_bDisarmed;
	GameTime_t m_flNextAttackTime;
	ParticleIndex_t m_nFXIndex;
	bool m_bAutoSpawn;
};
