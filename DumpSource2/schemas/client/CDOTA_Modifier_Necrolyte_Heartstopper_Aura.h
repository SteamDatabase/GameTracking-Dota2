class CDOTA_Modifier_Necrolyte_Heartstopper_Aura : public CDOTA_Buff
{
	float32 aura_radius;
	bool m_bStackCountChanged;
	CUtlVector< GameTime_t > m_fStackExpireTimes;
};
