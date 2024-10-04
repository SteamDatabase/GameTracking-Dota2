class CDOTA_Modifier_AbyssalUnderlord_DarkRift : public CDOTA_Buff
{
	ParticleIndex_t m_nfxTargetTp;
	float32 radius;
	int32 duration;
	ParticleIndex_t m_nfxAmbientFx;
	bool bPointTarget;
	Vector vDestination;
}
