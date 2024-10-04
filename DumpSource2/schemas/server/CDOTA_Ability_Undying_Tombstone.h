class CDOTA_Ability_Undying_Tombstone : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_vZombies;
	CHandle< CBaseEntity > hTombstone;
	float32 radius;
	float32 duration;
}
