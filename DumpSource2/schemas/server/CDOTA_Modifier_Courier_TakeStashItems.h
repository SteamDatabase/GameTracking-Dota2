class CDOTA_Modifier_Courier_TakeStashItems : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hStashOwner;
	Vector m_vLocation;
	bool m_bTransferAfterTake;
	int32 stash_pickup_distance;
};
