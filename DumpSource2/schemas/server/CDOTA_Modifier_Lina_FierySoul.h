class CDOTA_Modifier_Lina_FierySoul : public CDOTA_Buff
{
	int32 fiery_soul_attack_speed_bonus;
	int32 fiery_soul_magic_resist;
	float32 fiery_soul_move_speed_bonus;
	int32 fiery_soul_max_stacks;
	float32 fiery_soul_stack_duration;
	ParticleIndex_t m_nFXIndex;
	GameTime_t m_flFierySoulDieTime;
	GameTime_t m_flLastFierySoulFullStackTime;
};
