class CDOTA_Modifier_TangoHeal : public CDOTA_Buff
{
	float32 health_regen;
	bool superheal;
	float32 m_fHealingDone;
	float32 m_fUseSpeed;
	CUtlString m_sAbilityClassname;
};
