class CDOTA_Modifier_Bane_Ichor_Of_Nyctasha : public CDOTA_Buff
{
	GameTime_t m_flLastCalculationTime;
	float32 m_flTotalAttributes;
	float32 m_flOriginalStrength;
	float32 m_flOriginalAgility;
	float32 m_flOriginalIntellect;
	bool m_bIgnoreInCalc;
};
