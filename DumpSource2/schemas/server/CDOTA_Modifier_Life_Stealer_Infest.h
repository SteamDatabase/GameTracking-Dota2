class CDOTA_Modifier_Life_Stealer_Infest : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	int32 m_nFXIndex;
	float32 self_regen;
	int32 m_nStartingHealth;
}
