class CLogicBranch
{
	bool m_bInValue;
	CUtlVector< CHandle< CBaseEntity > > m_Listeners;
	CEntityIOOutput m_OnTrue;
	CEntityIOOutput m_OnFalse;
};
