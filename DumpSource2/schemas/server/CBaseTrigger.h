class CBaseTrigger
{
	CEntityIOOutput m_OnStartTouch;
	CEntityIOOutput m_OnStartTouchAll;
	CEntityIOOutput m_OnEndTouch;
	CEntityIOOutput m_OnEndTouchAll;
	CEntityIOOutput m_OnTouching;
	CEntityIOOutput m_OnTouchingEachEntity;
	CEntityIOOutput m_OnNotTouching;
	CUtlVector< CHandle< CBaseEntity > > m_hTouchingEntities;
	CUtlSymbolLarge m_iFilterName;
	CHandle< CBaseFilter > m_hFilter;
	bool m_bDisabled;
};
