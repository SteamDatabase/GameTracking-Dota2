// MNetworkVarNames = "uint8 m_unCurrentArcanaKillStreak"
// MNetworkVarNames = "uint8 m_unBestArcanaKillStreak"
// MNetworkVarNames = "PlayerID_t m_nVictimPlayerID"
// MNetworkVarNames = "bool m_bArcanaKillstreakRecordBroken"
class C_DOTA_Unit_Hero_Spectre : public C_DOTA_BaseNPC_Hero
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnSpectreArcanaProgressChanged"
	uint8 m_unCurrentArcanaKillStreak;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnSpectreArcanaProgressChanged"
	uint8 m_unBestArcanaKillStreak;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnSpectreArcanaProgressChanged"
	PlayerID_t m_nVictimPlayerID;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnSpectreArcanaProgressChanged"
	bool m_bArcanaKillstreakRecordBroken;
};
