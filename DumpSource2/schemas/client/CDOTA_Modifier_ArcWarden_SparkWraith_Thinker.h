class CDOTA_Modifier_ArcWarden_SparkWraith_Thinker : public CDOTA_Buff
{
	float32 radius;
	float32 wraith_vision_radius;
	int32 wraith_speed;
	float32 activation_delay;
	float32 think_interval;
	float32 m_flSparkDamage;
	int32 m_nViewerID;
	int32 m_nViewerTeam;
	bool m_bActive;
	int32 maximum_targets;
	float32 second_wraith_damage_pct;
	float32 second_wraith_speed_pct;
};
