class CDOTA_Ability_VengefulSpirit_WaveOfTerror : public CDOTABaseAbility
{
	int32 wave_width;
	float32 wave_speed;
	int32 m_iProjectile;
	float32 vision_aoe;
	float32 vision_duration;
	int32 steal_pct;
	int32 damage;
	int32 m_nNumHeroesHit;
	CountdownTimer m_ViewerTimer;
};
