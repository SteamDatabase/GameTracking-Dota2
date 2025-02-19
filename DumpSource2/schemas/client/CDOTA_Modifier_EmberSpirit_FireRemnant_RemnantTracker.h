class CDOTA_Modifier_EmberSpirit_FireRemnant_RemnantTracker
{
	CUtlVector< CHandle< C_BaseEntity > > m_vActiveRemnants;
	CUtlVector< CHandle< C_BaseEntity > > m_vTrackingDelayedRemnants;
	int32 shard_charge_radius;
};
