class CDOTA_Modifier_EmberSpirit_FireRemnant_RemnantTracker : public CDOTA_Buff
{
	CUtlVector< CHandle< CBaseEntity > > m_vActiveRemnants;
	CUtlVector< CHandle< CBaseEntity > > m_vTrackingDelayedRemnants;
	int32 shard_charge_radius;
};
