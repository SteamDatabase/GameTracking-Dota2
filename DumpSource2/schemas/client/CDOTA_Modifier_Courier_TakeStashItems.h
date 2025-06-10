class CDOTA_Modifier_Courier_TakeStashItems : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hStashOwner;
	CHandle< C_BaseEntity > m_hTarget;
	Vector m_vLocation;
	bool m_bTransferAfterTake;
};
