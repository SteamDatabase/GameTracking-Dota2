class CDOTA_Modifier_Wisp_Relocate_Return : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hTarget;
	Vector m_vecReturnPosition;
	float32 return_time;
	ParticleIndex_t m_nFXTimeRemaining;
};
