class C_DOTA_Ability_Dazzle_ShadowWave : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
	int32 bounce_radius;
	int32 damage_radius;
	int32 damage;
	int32 max_targets;
	float32 scepter_heal_pct;
}
