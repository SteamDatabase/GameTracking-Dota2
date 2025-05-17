// MNetworkVarNames = "char m_pszNetworkedSoundLoop"
// MNetworkVarNames = "int m_nLoopingSoundParity"
class C_DOTA_Unit_LoopingSound : public C_DOTA_BaseNPC_Additive
{
	int32 m_nPrevLoopingSoundParity;
	// MNetworkEnable
	char[256] m_pszNetworkedSoundLoop;
	// MNetworkEnable
	int32 m_nLoopingSoundParity;
};
