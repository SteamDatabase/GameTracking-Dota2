class CDOTA_Modifier_Windrunner_FocusFire : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	int32 focusfire_damage_reduction;
	bool bActive;
	int32 bonus_attack_speed;
	int32 focusfire_fire_on_the_move;
	bool m_bPause;
	int32 m_nNumArrowsLanded;
	int32 m_nDamageDealt;
	int32 m_nDamageDealtMax;
	int32 m_nTargetInitialHP;
	bool m_bHeroKilled;
	bool m_bRecentFocusFireAttack;
	bool m_bFocusFireProcessProcs;
	ParticleIndex_t m_nFXFocusFire;
	GameTime_t m_flLastFocusFireAttackTime;
}
