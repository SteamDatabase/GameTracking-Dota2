class CDOTA_Modifier_ArcWarden_SparkWraith_Thinker : public CDOTA_Buff
{
	float32 radius;
	float32 scepter_radius;
	float32 wraith_vision_radius;
	int32 wraith_speed;
	float32 activation_delay;
	float32 scepter_activation_delay;
	float32 think_interval;
	float32 m_flSparkDamage;
	int32 m_nViewerID;
	int32 m_nViewerTeam;
	bool m_bActive;
	bool m_bOriginal;
}
