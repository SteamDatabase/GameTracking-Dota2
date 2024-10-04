class CDOTA_Ability_EmberSpirit_SleightOfFist : public CDOTABaseAbility
{
	Vector m_vCastLoc;
	int32 m_nHeroesKilled;
	CUtlVector< CHandle< CBaseEntity > > m_hAttackEntities;
	ParticleIndex_t m_nFXMarkerIndex;
	CHandle< CBaseEntity > m_hDoubleHitEntity;
}
