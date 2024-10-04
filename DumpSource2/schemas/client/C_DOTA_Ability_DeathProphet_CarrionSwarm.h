class C_DOTA_Ability_DeathProphet_CarrionSwarm : public C_DOTABaseAbility
{
	int32 start_radius;
	int32 end_radius;
	GameTime_t m_fStartTime;
	float32 m_fTotalTime;
	int32 m_nProjectileHandle;
	ParticleIndex_t m_nFXIndex;
}
