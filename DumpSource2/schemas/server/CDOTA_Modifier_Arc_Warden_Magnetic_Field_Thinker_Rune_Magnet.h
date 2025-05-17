class CDOTA_Modifier_Arc_Warden_Magnetic_Field_Thinker_Rune_Magnet : public CDOTA_Buff
{
	float32 radius;
	float32 rune_pull_strength;
	float32 rune_pull_max_speed_as_multiplier_of_pull_strength;
	float32 rune_activate_radius_buffer;
	float32 rune_pull_falloff_multiplier;
	float32 rune_pull_radius;
	GameTime_t m_flLastThinkTime;
	GameTime_t m_flBubbleExpirationTime;
};
