// MNetworkVarNames = "Vector m_vDirection"
// MNetworkVarNames = "float m_fDirectionVariation"
// MNetworkVarNames = "float m_fSpeed"
// MNetworkVarNames = "float m_fSpeedVariation"
// MNetworkVarNames = "float m_fTurbulence"
// MNetworkVarNames = "float m_fVolumeSizeXY"
// MNetworkVarNames = "float m_fVolumeSizeZ"
// MNetworkVarNames = "float m_fVolumeMinSpacing"
// MNetworkVarNames = "int m_nVolumeResolutionXY"
// MNetworkVarNames = "int m_nVolumeResolutionZ"
// MNetworkVarNames = "bool m_bIsMaster"
class CEnvWindController : public CBaseEntity
{
	// MNetworkEnable
	Vector m_vDirection;
	// MNetworkEnable
	float32 m_fDirectionVariation;
	// MNetworkEnable
	float32 m_fSpeed;
	// MNetworkEnable
	float32 m_fSpeedVariation;
	// MNetworkEnable
	float32 m_fTurbulence;
	// MNetworkEnable
	float32 m_fVolumeSizeXY;
	// MNetworkEnable
	float32 m_fVolumeSizeZ;
	// MNetworkEnable
	float32 m_fVolumeMinSpacing;
	// MNetworkEnable
	int32 m_nVolumeResolutionXY;
	// MNetworkEnable
	int32 m_nVolumeResolutionZ;
	// MNetworkEnable
	bool m_bIsMaster;
	bool m_bFirstTime;
};
