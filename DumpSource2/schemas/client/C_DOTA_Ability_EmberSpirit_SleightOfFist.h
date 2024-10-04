class C_DOTA_Ability_EmberSpirit_SleightOfFist : public C_DOTABaseAbility
{
	Vector m_vCastLoc;
	int32 m_nHeroesKilled;
	CUtlVector< CHandle< C_BaseEntity > > m_hAttackEntities;
	ParticleIndex_t m_nFXMarkerIndex;
}
