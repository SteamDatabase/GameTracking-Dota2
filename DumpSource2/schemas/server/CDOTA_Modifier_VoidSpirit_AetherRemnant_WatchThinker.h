class CDOTA_Modifier_VoidSpirit_AetherRemnant_WatchThinker : public CDOTA_Buff
{
	float32 remnant_watch_radius;
	GameTime_t m_flLastDamageTick;
	float32 damage_tick_rate;
	float32 m_flDamage;
	bool m_bPiercesCreeps;
	bool bIsArtifice;
	float32 artifice_pct_effectiveness;
};
