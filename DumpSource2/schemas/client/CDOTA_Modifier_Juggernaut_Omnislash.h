class CDOTA_Modifier_Juggernaut_Omnislash : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hTarget;
	CHandle< C_BaseEntity > m_hLastTarget;
	int32 m_nJumps;
	int32 bonus_damage;
	int32 bonus_attack_speed;
	float32 omni_slash_radius;
	float32 attack_rate_multiplier;
	bool m_bFirstHit;
	int32 m_iTotalDamage;
	int32 m_iHeroDamage;
	int32 m_iKilledHeroes;
	GameTime_t m_fNextAttackTime;
	bool m_bScepterCast;
	bool m_bReflection;
	bool m_bEndNext;
}
