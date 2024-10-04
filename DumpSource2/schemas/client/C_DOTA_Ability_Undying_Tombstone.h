class C_DOTA_Ability_Undying_Tombstone : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > m_vZombies;
	CHandle< C_BaseEntity > hTombstone;
	float32 radius;
	float32 duration;
}
