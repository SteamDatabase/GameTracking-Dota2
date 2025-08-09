// MGetKV3ClassDefaults = {
//	"m_eCancelInput": "",
//	"m_eCancelInput2": "",
//	"m_eCancelInput3": "",
//	"m_nCancelStart": -1,
//	"m_nCancelDuration": -1,
//	"m_nCancelInputBuffer": -1,
//	"m_bRequiresInstall": false,
//	"m_bAllowCancelOnWhiff": false,
//	"m_nCancelActionID": "INVALID_ACTION_DEFINITION",
//	"m_strCancelActionName": ""
//}
// MVDataRoot
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
};
