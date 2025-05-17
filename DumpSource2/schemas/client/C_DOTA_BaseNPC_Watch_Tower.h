// MNetworkVarNames = "string_t m_szOutpostName"
// MNetworkVarNames = "string_t m_szInteractAbilityName"
class C_DOTA_BaseNPC_Watch_Tower : public C_DOTA_BaseNPC_Building
{
	ParticleIndex_t m_iRangeFX;
	// MNetworkEnable
	CUtlSymbolLarge m_szOutpostName;
	// MNetworkEnable
	CUtlSymbolLarge m_szInteractAbilityName;
};
