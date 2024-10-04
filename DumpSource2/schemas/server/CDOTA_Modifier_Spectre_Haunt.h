class CDOTA_Modifier_Spectre_Haunt : public CDOTA_Buff
{
	bool m_bRealityApplied;
	int32 destroy_if_target_is_dead;
	GameTime_t m_fStartAttackTime;
	CHandle< CBaseEntity > hTarget;
	bool m_bTargetIsAlive;
}
