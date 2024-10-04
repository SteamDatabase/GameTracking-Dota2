class CDOTA_Modifier_Item_Lotus_Orb_ChannelCheck : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hCurrentAbility;
	CHandle< C_BaseEntity > m_hTarget;
	Vector m_vLocation;
	GameTime_t m_fChannelEnd;
	bool m_bInterrupt;
	bool m_bExpired;
}
