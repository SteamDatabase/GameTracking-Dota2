class CDOTA_Modifier_VoidSpirit_Dissimilate_Phase
{
	Vector m_vFirstPortalPos;
	CUtlVector< Vector > m_vecDestinations;
	CUtlVector< ParticleIndex_t > m_vecDestinationParticles;
	CUtlVector< ParticleIndex_t > m_vecDestinationParticles_EnemyTeam;
	int32 m_nCurrentDestinationIndex;
	int32 m_nClosestIndexPosToClick;
	int32 m_nPortalHeightOffset;
	char* m_szAlliesPortalFX;
	char* m_szEnemiesPortalFX;
	int32 m_nPortalRadius;
	int32 m_nPortalPadding;
	int32 m_nFinalImpactDamageRadius;
	int32 m_nFinalImpactFXRadius;
	int32 destination_fx_radius;
	int32 damage_radius;
	int32 portals_per_ring;
	int32 angle_per_ring_portal;
	int32 first_ring_distance_offset;
	float32 debuff_duration;
	int32 aether_remnant_count;
	float32 artifice_extra_offset;
};
