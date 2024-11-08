class CDOTA_Modifier_Kez_ShodoSai_Parry : public CDOTA_Buff
{
	int32 m_nPoseParameterWE;
	int32 m_nPoseParameterNS;
	float32 m_flLastPoseX;
	float32 m_flLastPoseY;
	int32 m_nLastMaxDirection;
	Vector m_vLastOrigin;
	GameTime_t m_flLastGameTime;
	int32 speed_penalty;
	int32 forward_angle;
	float32 vuln_duration;
	float32 parry_window_duration;
	float32 parry_stun_duration;
	CUtlVector< CHandle< C_BaseEntity > > m_vecParriedEnemies;
	Vector m_vFacing;
	float32 m_flFacingTarget;
	float32 m_flLastOverheadTime;
	ParticleIndex_t m_nFXIndex;
	CHandle< C_BaseEntity > m_hVulnAttackTarget;
	bool m_bAttackingVuln;
};
