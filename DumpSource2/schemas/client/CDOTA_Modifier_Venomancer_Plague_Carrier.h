class CDOTA_Modifier_Venomancer_Plague_Carrier : public CDOTA_Buff
{
	CHandle< C_DOTA_BaseNPC > m_hAttachTarget;
	int32 m_nWardIndex;
	float32 m_flPositioningAngle;
	float32 m_flTargetPreviousYaw;
	ParticleIndex_t m_nFXIndex;
};
