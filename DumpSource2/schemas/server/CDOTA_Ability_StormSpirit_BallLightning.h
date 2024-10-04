class CDOTA_Ability_StormSpirit_BallLightning : public CDOTABaseAbility
{
	bool m_bHasAutoRemnantTalent;
	float32 m_fAutoRemnantInterval;
	int32 ball_lightning_initial_mana_base;
	float32 ball_lightning_initial_mana_percentage;
	int32 ball_lightning_travel_cost_base;
	float32 ball_lightning_travel_cost_percent;
	int32 m_iProjectileID;
	Vector m_vStartLocation;
	Vector m_vProjectileLocation;
	float32 m_fDistanceAccumulator;
	float32 m_fTalentDistanceAccumulator;
	int32 scepter_remnant_interval;
}
