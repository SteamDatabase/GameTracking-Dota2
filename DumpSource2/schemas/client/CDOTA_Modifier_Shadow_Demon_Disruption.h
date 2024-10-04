class CDOTA_Modifier_Shadow_Demon_Disruption : public CDOTA_Buff
{
	float32 m_flHealth;
	float32 m_flDisseminate_Duration;
	CHandle< C_BaseEntity > m_hDisseminateAbility;
	bool m_bCanCast;
}
