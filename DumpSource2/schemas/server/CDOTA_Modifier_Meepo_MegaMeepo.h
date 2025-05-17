class CDOTA_Modifier_Meepo_MegaMeepo : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	float32 m_flOffset;
	QAngle m_vStartAngles;
	Vector m_vStartLocation;
	float32 animation_rate;
	bool m_bInterrupted;
	bool m_bHasBeenDestroyed;
	bool m_bIsHighestMeepo;
};
