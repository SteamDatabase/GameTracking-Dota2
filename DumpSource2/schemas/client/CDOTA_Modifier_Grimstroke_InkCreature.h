class CDOTA_Modifier_Grimstroke_InkCreature
{
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nAmbientFXIndex;
	int32 m_nAttackCount;
	bool m_bIsLatched;
	CHandle< C_BaseEntity > m_hAttachTarget;
	CountdownTimer m_EnemyVision;
	float32 latch_duration;
	float32 speed;
	int32 destroy_attacks;
	int32 hero_attack_multiplier;
};
