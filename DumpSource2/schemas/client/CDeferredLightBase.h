// MNetworkVarNames = "Color m_LightColor"
// MNetworkVarNames = "float m_flIntensity"
// MNetworkVarNames = "float m_flLightSize"
// MNetworkVarNames = "float m_flSpotFoV"
// MNetworkVarNames = "QAngle m_vLightDirection"
// MNetworkVarNames = "float m_flStartFalloff"
// MNetworkVarNames = "float m_flDistanceFalloff"
// MNetworkVarNames = "uint m_nFlags"
// MNetworkVarNames = "char m_ProjectedTextureName"
class CDeferredLightBase
{
	// MNetworkEnable
	Color m_LightColor;
	// MNetworkEnable
	float32 m_flIntensity;
	// MNetworkEnable
	float32 m_flLightSize;
	// MNetworkEnable
	float32 m_flSpotFoV;
	// MNetworkEnable
	QAngle m_vLightDirection;
	// MNetworkEnable
	float32 m_flStartFalloff;
	// MNetworkEnable
	float32 m_flDistanceFalloff;
	// MNetworkEnable
	uint32 m_nFlags;
	// MNetworkEnable
	char[512] m_ProjectedTextureName;
};
