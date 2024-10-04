class CDOTAFightingGameCancelOptionDefinition
{
	EFightingGameButtonBit m_eCancelInput;
	EFightingGameButtonBit m_eCancelInput2;
	EFightingGameButtonBit m_eCancelInput3;
	int32 m_nCancelStart;
	int32 m_nCancelDuration;
	int32 m_nCancelInputBuffer;
	bool m_bRequiresInstall;
	bool m_bAllowCancelOnWhiff;
	EFightingGameActionID m_nCancelActionID;
	CUtlString m_strCancelActionName;
}
