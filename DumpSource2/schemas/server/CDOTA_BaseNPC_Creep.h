// MNetworkVarNames = "float m_flAim"
class CDOTA_BaseNPC_Creep : public CDOTA_BaseNPC_Additive
{
	CDOTA_CreepKillInfo m_KillInfo;
	DOTA_LANE m_Lane;
	bool m_bPushback;
	// MNetworkEnable
	float32 m_flAim;
};
