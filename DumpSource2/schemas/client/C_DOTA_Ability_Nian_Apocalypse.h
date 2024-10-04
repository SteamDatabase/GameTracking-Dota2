class C_DOTA_Ability_Nian_Apocalypse : public C_DOTABaseAbility
{
	int32 area_of_effect;
	ParticleIndex_t m_nfxIndex_roar;
	float32 fire_interval;
	float32 delay;
	float32 target_range;
	CountdownTimer m_ctTimer;
	float32 m_flTiming;
};
