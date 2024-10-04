class CDOTA_Modifier_Courier_TakeStashItems : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hStashOwner;
	Vector m_vLocation;
	bool m_bTransferAfterTake;
	int32 stash_pickup_distance;
}
