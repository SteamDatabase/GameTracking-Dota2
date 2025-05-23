class CDOTA_Modifier_Invoker_GhostWalk_Self : public CDOTA_Modifier_Invisible
{
	int32 self_slow;
	int32 apply_ice_wall_debuff;
	float32 area_of_effect;
	float32 aura_fade_time;
	float32 health_regen;
	float32 mana_regen;
	float32 disable_time;
	GameTime_t m_timeLastDamage;
};
