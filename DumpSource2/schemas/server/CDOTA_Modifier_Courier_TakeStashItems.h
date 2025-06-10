class CDOTA_Modifier_Courier_TakeStashItems : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hStashOwner;
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vLocation;
	bool m_bTransferAfterTake;
};
