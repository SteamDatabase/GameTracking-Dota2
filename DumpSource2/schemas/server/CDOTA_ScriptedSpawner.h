class CDOTA_ScriptedSpawner
{
	CUtlSymbolLarge m_szNPCFirstWaypoint;
	int32 m_nNPCType;
	bool m_bAllowRelaxation;
	bool m_bPlayPostVictoryAnims;
	bool m_bDisableAutoAttack;
	bool m_bAutomaticallyRespawn;
	bool m_bInvulnerable;
	bool m_bAllowHeroTargets;
	int32 m_nActivityOverride;
	float32 m_flDuration;
	bool m_bAnimationFireOnce;
	CUtlVector< CDOTA_ScriptedSpawner::scripted_moveto_t > m_hMoveToTargets;
	CEntityIOOutput m_OnAllUnitsKilled;
	CEntityIOOutput m_OnUnitKilled;
	CEntityIOOutput m_OnHealthLow;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_Units;
	CHandle< CBaseEntity > m_hSpawnpoint;
	CUtlSymbolLarge m_szCustomNPCName;
};
