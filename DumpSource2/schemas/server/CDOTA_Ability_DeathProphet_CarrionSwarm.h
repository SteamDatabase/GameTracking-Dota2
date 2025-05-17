class CDOTA_Ability_DeathProphet_CarrionSwarm : public CDOTABaseAbility
{
	float32 start_radius;
	float32 end_radius;
	GameTime_t m_fStartTime;
	float32 m_fTotalTime;
	int32 m_nProjectileHandle;
	ParticleIndex_t m_nFXIndex;
};
