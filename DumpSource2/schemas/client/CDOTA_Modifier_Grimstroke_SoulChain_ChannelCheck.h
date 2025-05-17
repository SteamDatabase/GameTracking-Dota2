class CDOTA_Modifier_Grimstroke_SoulChain_ChannelCheck : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hCurrentAbility;
	CHandle< C_BaseEntity > m_hTarget;
	CUtlVector< CHandle< C_BaseEntity > > m_hAbilities;
	Vector m_vLocation;
	GameTime_t m_fChannelEnd;
	bool m_bInterrupt;
	bool m_bExpired;
};
