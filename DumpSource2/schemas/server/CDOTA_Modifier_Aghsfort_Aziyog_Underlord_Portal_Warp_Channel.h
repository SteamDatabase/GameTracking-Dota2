class CDOTA_Modifier_Aghsfort_Aziyog_Underlord_Portal_Warp_Channel
{
	ParticleIndex_t m_nfxTargetTp;
	ParticleIndex_t m_nfxTargetTp2;
	ParticleIndex_t m_nfxAmbientFx;
	ParticleIndex_t m_nfxPortal1;
	ParticleIndex_t m_nfxPortal2;
	CHandle< CBaseEntity > m_hPortal;
	Vector m_vStartPosition;
	float32 m_flTotalTime;
	float32 m_flElapsedTimePortion;
	float32 animation_rate;
	int32 stop_distance;
};
