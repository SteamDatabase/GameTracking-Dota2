class CDOTA_Modifier_Slark_ShadowDance : public CDOTA_Modifier_Invisible
{
	CHandle< C_BaseEntity > m_hVisibleEntity;
	ParticleIndex_t m_nFXIndex;
	int32 unlink_vision;
}
