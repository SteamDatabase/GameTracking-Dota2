class CDOTA_Modifier_EarthSpirit_StoneCaller_Innate : public CDOTA_Buff
{
	float32 attack_damage_per_stone;
	float32 attack_damage_per_stone_used;
	float32 buff_duration;
	GameTime_t m_ExpireTime;
};
