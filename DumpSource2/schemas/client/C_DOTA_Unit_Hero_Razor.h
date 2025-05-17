// MNetworkVarNames = "int m_nTargetAngle"
// MNetworkVarNames = "int m_nTargetRange"
class C_DOTA_Unit_Hero_Razor : public C_DOTA_BaseNPC_Hero
{
	int32 m_iPoseParameterAim;
	int32 m_iPoseParameterRange;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_nTargetAngle;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_nTargetRange;
};
