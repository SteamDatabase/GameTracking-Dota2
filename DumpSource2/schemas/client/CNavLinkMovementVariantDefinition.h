// MGetKV3ClassDefaults = {
//	"m_sExternalGraphName": "",
//	"m_vecConditions":
//	[
//	]
//}
class CNavLinkMovementVariantDefinition
{
	// MPropertyDescription = "External nav link animgraph to connect to the NPC when using the navlink"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCNmGraphDefinition > > m_sExternalGraphName;
	CUtlVector< CNavLinkConditions > m_vecConditions;
};
