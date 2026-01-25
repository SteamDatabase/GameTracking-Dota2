// MGetKV3ClassDefaults = {
//	"m_sToolsOnlyOwnerModelName": "",
//	"m_vecAnimgraphVars":
//	[
//	],
//	"m_vecVariants":
//	[
//	]
//}
// MVDataRoot
class CNavLinkMovementVData
{
	// MPropertyDescription = "Model used by the tools only to populate comboboxes for things like animgraph parameter pickers"
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sToolsOnlyOwnerModelName;
	// MPropertyFriendlyName = "Animgraph Variables"
	// MPropertyDescription = "List of animgraph variables to use when moving through this navlink. Can include multiple, with different amounts of angular slack. The most permissive animgraph variable that exists on the entity's animgraph will be used,"
	// MPropertyAutoExpandSelf
	CUtlVector< CNavLinkAnimgraphVar > m_vecAnimgraphVars;
	CUtlVector< CNavLinkMovementVariantDefinition > m_vecVariants;
};
