class CDOTA_Ability_Puck_IllusoryOrb : public CDOTABaseAbility
{
	int32 m_iProjectile;
	CountdownTimer m_ViewerTimer;
	int32 curve_orb;
	float32 m_fTimeRemaining;
	float32 m_fElapsedTime;
	Vector m_vVectorTargetEndpoint;
	Vector m_vCurveAcceleration;
	Vector m_vStartPosition;
	float32 orb_vision;
	float32 max_distance;
	float32 vision_duration;
	int32 damage;
	float32 increase_per_sec;
	float32 damage_interval;
	float32 radius;
	float32 damage_over_time_pct;
	CSoundPatch* m_pSoundPatch;
	ParticleIndex_t m_nCurvePathFXIndex;
};
