class CDOTA_Ability_AghsFort_DragonKnight_BreatheFire : public CDOTABaseAbility
{
	ParticleIndex_t m_nPreviewFX;
	int32 start_radius;
	int32 end_radius;
	Vector m_vStartPos;
	GameTime_t m_fStartTime;
	float32 m_fTotalTime;
};
