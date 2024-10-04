class CDOTA_Modifier_Boss_DarkWillow_Bedlam : public CDOTA_Buff
{
	float32 m_flRotation;
	CHandle< C_BaseEntity > m_hWisp;
	GameTime_t m_flLastAttack;
	bool reversed;
	int32 roaming_radius;
	int32 attack_radius;
	float32 roaming_seconds_per_rotation;
	float32 attack_interval;
	bool m_bSetupWarning;
	ParticleIndex_t m_nPreviewFX;
};
