class CDOTA_Modifier_Silencer_GlaivesOfWisdom : public CDOTA_Buff
{
	float32 intellect_damage_pct;
	CUtlVector< int16 > m_InFlightAttackRecords;
	CUtlVector< int16 > m_InFlightSilenceAttackRecords;
	CDOTA_Buff* m_pAttackCounterBuff;
};
