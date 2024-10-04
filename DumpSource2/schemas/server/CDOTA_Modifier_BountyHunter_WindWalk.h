class CDOTA_Modifier_BountyHunter_WindWalk : public CDOTA_Modifier_Invisible
{
	int32 damage_reduction_pct;
	float32 shard_stun_duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
}
