// MNetworkVarNames = "char m_pszNetworkedSoundLoop"
// MNetworkVarNames = "int m_nLoopingSoundParity"
class CDOTA_Unit_LoopingSound : public CDOTA_BaseNPC_Additive
{
	// MNetworkEnable
	char[256] m_pszNetworkedSoundLoop;
	// MNetworkEnable
	int32 m_nLoopingSoundParity;
};
