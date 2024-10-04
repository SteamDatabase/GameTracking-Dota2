class CDOTA_Modifier_Undying_Tombstone_Zombie_Deathstrike : public CDOTA_Buff
{
	float32 radius;
	float32 health_threshold_pct;
	float32 duration;
	CHandle< CDOTABaseAbility > m_hTombstoneSourceAbility;
	CHandle< CBaseEntity > m_hChaseUnit;
}
