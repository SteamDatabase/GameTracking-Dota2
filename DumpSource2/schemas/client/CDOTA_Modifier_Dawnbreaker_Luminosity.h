class CDOTA_Modifier_Dawnbreaker_Luminosity : public CDOTA_Buff
{
	bool m_bAppliesToCreeps;
	int32 attack_count;
	bool triggered_by_celestial_hammer;
	bool m_bShouldIncrement;
	int32 m_nStackCount;
};
