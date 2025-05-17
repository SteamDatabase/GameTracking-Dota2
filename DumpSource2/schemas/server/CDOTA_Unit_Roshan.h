// MNetworkVarNames = "bool m_bGoldenRoshan"
class CDOTA_Unit_Roshan : public CDOTA_BaseNPC_Additive
{
	int32 m_iKillerTeam;
	int32 m_iLastHealthPercent;
	ParticleIndex_t m_nFXIndex;
	CHandle< CBaseEntity > m_hRadiantRoshanPit;
	CHandle< CBaseEntity > m_hDireRoshanPit;
	CHandle< CBaseEntity > m_hRiverMidpoint;
	CUtlVector< CHandle< CBaseEntity > > m_hAttackingHeroes;
	// MNetworkEnable
	bool m_bGoldenRoshan;
};
