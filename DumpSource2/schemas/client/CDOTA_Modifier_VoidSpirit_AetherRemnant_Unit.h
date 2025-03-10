class CDOTA_Modifier_VoidSpirit_AetherRemnant_Unit
{
	Vector m_vFacingDir;
	CUtlVector< CHandle< C_BaseEntity > > m_hWatchPathThinkers;
	ParticleIndex_t m_nBeamFXIndex;
	CUtlVector< int32 > m_nViewerIDs;
	int32 m_nViewerTeam;
	float32 remnant_watch_distance;
	float32 remnant_watch_radius;
	float32 duration;
	int32 watch_path_vision_radius;
	int32 impact_damage;
	float32 pull_duration;
	float32 activation_delay;
	bool m_bPiercesCreeps;
	CUtlVector< CHandle< C_BaseEntity > > m_hAlreadyHit;
	bool bIsArtifice;
	float32 artifice_duration_override;
	float32 artifice_pct_effectiveness;
};
