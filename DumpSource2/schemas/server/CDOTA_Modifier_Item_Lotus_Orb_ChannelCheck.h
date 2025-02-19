class CDOTA_Modifier_Item_Lotus_Orb_ChannelCheck
{
	CHandle< CBaseEntity > m_hCurrentAbility;
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vLocation;
	GameTime_t m_fChannelEnd;
	bool m_bInterrupt;
	bool m_bExpired;
};
