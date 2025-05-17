class CDOTA_Modifier_Ringmaster_Wheel_Mesmerize_Pull : public CDOTA_Buff
{
	float32 m_fMovementSpeed;
	CHandle< CDOTA_BaseNPC > m_hPullTarget;
	float32 think_interval;
	float32 mesmerize_radius;
	float32 k_flCloseThreshold;
};
