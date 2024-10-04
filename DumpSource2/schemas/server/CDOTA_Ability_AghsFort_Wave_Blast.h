class CDOTA_Ability_AghsFort_Wave_Blast : public CDOTABaseAbility
{
	int32 damage;
	float32 knockback_duration;
	float32 disarm_duration;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
	ParticleIndex_t m_nPreviewFX;
}
