class CEnvDeferredLight : public CModelPointEntity
{
	CHandle< CBaseEntity > m_hTargetEntity;
	Color m_LightColor;
	float32 m_flIntensity;
	float32 m_flLightSize;
	float32 m_flSpotFoV;
	QAngle m_vLightDirection;
	float32 m_flStartFalloff;
	float32 m_flDistanceFalloff;
	uint32 m_nFlags;
	char[512] m_ProjectedTextureName;
}
