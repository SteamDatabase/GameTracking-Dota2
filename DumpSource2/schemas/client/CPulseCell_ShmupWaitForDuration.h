// MGetKV3ClassDefaults = {
//	"_class": "CPulseCell_ShmupWaitForDuration",
//	"m_nEditorNodeID": -1,
//	"m_WakeResume":
//	{
//		"m_SourceOutflowName": "",
//		"m_nDestChunk": -1,
//		"m_nInstruction": -1
//	}
//}
// MPropertyFriendlyName = "Shmup Wait For Duration"
class CPulseCell_ShmupWaitForDuration : public CPulseCell_BaseYieldingInflow
{
	CPulse_ResumePoint m_WakeResume;
};
