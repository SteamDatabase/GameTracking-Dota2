class CDOTA_Modifier_VoidSpirit_Dissimilate_Phase
{
	Vector m_vFirstPortalPos;
	CUtlVector< Vector > m_vecDestinations;
	CUtlVector< ParticleIndex_t > m_vecDestinationParticles;
	CUtlVector< ParticleIndex_t > m_vecDestinationParticles_EnemyTeam;
	int32 m_nCurrentDestinationIndex;
	int32 m_nClosestIndexPosToClick;
	int32 m_flPortalHeightOffset;
	char* m_szAlliesPortalFX;
	char* m_szEnemiesPortalFX;
	float32 m_flPortalRadius;
	float32 m_flPortalPadding;
	float32 m_flFinalImpactDamageRadius;
	float32 m_flFinalImpactFXRadius;
	float32 destination_fx_radius;
	float32 damage_radius;
	int32 portals_per_ring;
	int32 angle_per_ring_portal;
	float32 first_ring_distance_offset;
	float32 debuff_duration;
	int32 aether_remnant_count;
	float32 artifice_extra_offset;
};
