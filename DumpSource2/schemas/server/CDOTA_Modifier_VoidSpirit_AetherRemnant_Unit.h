class CDOTA_Modifier_VoidSpirit_AetherRemnant_Unit : public CDOTA_Buff
{
	Vector m_vFacingDir;
	CUtlVector< CHandle< CBaseEntity > > m_hWatchPathThinkers;
	ParticleIndex_t m_nBeamFXIndex;
	CUtlVector< int32 > m_nViewerIDs;
	int32 m_nViewerTeam;
	int32 remnant_watch_distance;
	int32 remnant_watch_radius;
	float32 duration;
	int32 watch_path_vision_radius;
	int32 impact_damage;
	float32 pull_duration;
	float32 activation_delay;
	bool m_bPiercesCreeps;
	CUtlVector< CHandle< CBaseEntity > > m_hAlreadyHit;
	bool bIsArtifice;
	float32 artifice_duration_override;
	float32 artifice_pct_effectiveness;
};
