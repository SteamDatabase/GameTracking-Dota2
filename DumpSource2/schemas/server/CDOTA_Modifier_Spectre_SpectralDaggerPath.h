class CDOTA_Modifier_Spectre_SpectralDaggerPath
{
	CUtlVector< CHandle< CBaseEntity > > m_hUnitsInPath;
	int32 path_radius;
	int32 vision_radius;
	int32 dagger_radius;
	float32 buff_persistence;
	float32 dagger_grace_period;
	float32 dagger_path_duration;
};
