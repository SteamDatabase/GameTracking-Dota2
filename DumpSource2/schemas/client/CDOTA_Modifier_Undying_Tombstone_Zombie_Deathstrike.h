class CDOTA_Modifier_Undying_Tombstone_Zombie_Deathstrike : public CDOTA_Buff
{
	float32 radius;
	float32 health_threshold_pct;
	float32 duration;
	CHandle< C_DOTABaseAbility > m_hTombstoneSourceAbility;
	CHandle< C_BaseEntity > m_hChaseUnit;
};
