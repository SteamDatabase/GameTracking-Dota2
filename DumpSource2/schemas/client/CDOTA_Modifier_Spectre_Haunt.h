class CDOTA_Modifier_Spectre_Haunt
{
	int32 destroy_if_target_is_dead;
	GameTime_t m_fStartAttackTime;
	CHandle< C_BaseEntity > hTarget;
	bool m_bTargetIsAlive;
};
