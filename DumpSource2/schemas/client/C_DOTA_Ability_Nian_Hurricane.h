class C_DOTA_Ability_Nian_Hurricane : public C_DOTABaseAbility
{
	int32 min_distance;
	int32 max_distance;
	int32 torrent_count;
	float32 fire_interval;
	float32 pull_switch_interval;
	float32 game_time_wind_activation;
	CountdownTimer m_ctPullTimer;
	CountdownTimer m_ctTimer;
	float32 m_flTiming;
	bool m_bForward;
	bool m_bUseWind;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nfxIndex_roar;
};
