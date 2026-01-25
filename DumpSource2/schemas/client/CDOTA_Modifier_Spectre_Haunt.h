class CDOTA_Modifier_Spectre_Haunt : public CDOTA_Buff
{
	int32 destroy_if_target_is_dead;
	GameTime_t m_fStartAttackTime;
	CHandle< C_BaseEntity > m_hTarget;
	bool m_bTargetIsAlive;
};
