class CDOTA_Modifier_Grimstroke_SoulChain_ChannelCheck
{
	CHandle< CBaseEntity > m_hCurrentAbility;
	CHandle< CBaseEntity > m_hTarget;
	CUtlVector< CHandle< CBaseEntity > > m_hAbilities;
	Vector m_vLocation;
	GameTime_t m_fChannelEnd;
	bool m_bInterrupt;
	bool m_bExpired;
};
