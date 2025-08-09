// MGetKV3ClassDefaults = {
//	"_class": "CPulseCell_WaitForPanelClass",
//	"m_nEditorNodeID": -1,
//	"m_WakeResume":
//	{
//		"m_SourceOutflowName": "",
//		"m_nDestChunk": -1,
//		"m_nInstruction": -1
//	}
//}
// MCellForDomain = "PanoramaPanel"
// MPulseCellMethodBindings (UNKNOWN FOR PARSER)
// MPulseCellOutflowHookInfo (UNKNOWN FOR PARSER)
// MPropertyFriendlyName = "Wait For Panel Class"
class CPulseCell_WaitForPanelClass : public CPulseCell_BaseYieldingInflow
{
	CPulse_ResumePoint m_WakeResume;
};
