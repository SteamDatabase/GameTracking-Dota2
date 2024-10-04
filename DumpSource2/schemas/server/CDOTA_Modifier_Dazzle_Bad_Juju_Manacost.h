class CDOTA_Modifier_Dazzle_Bad_Juju_Manacost : public CDOTA_Buff
{
	float32 mana_cost_increase_duration;
	CUtlVector< GameTime_t > m_vecExpirationTimes;
};
