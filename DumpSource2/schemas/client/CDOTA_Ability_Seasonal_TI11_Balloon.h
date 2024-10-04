class CDOTA_Ability_Seasonal_TI11_Balloon : public C_DOTABaseAbility
{
	float32 charge_use_interval;
	float32 max_usable_charges;
	GameTime_t m_flLastChargeUseTime;
	CHandle< C_BaseEntity > m_hBalloon;
}
