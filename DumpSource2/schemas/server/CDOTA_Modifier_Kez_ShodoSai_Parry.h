class CDOTA_Modifier_Kez_ShodoSai_Parry : public CDOTA_Buff
{
	int32 speed_penalty;
	int32 forward_angle;
	float32 vuln_duration;
	float32 parry_window_duration;
	float32 parry_stun_duration;
	CUtlVector< CHandle< CBaseEntity > > m_vecParriedEnemies;
	Vector m_vFacing;
	float32 m_flFacingTarget;
	float32 m_flLastOverheadTime;
	ParticleIndex_t m_nFXIndex;
	CHandle< CBaseEntity > m_hVulnAttackTarget;
	bool m_bAttackingVuln;
};
