// MGetKV3ClassDefaults = {
//	"Node1": "",
//	"Node2": "",
//	"bOneWay": false,
//	"flCircleInvRadius": 0.000000,
//	"color":
//	[
//		255,
//		255,
//		255
//	]
//}
// MVDataOutlinerIconExpr = "'tools/images/common/icon_edge_generic.png'"
// MVDataAnonymousNode
class BlessingPath_t
{
	// MPropertyAttributeEditor = "VDataNodePicker(//m_mapBlessings/*)"
	CUtlString Node1;
	// MPropertyAttributeEditor = "VDataNodePicker(//m_mapBlessings/*)"
	CUtlString Node2;
	// MPropertyDescription = "This edge only allows unlocks in the direction of the arrow."
	bool bOneWay;
	// MPropertyAttributeRange = "-1 1"
	// MPropertyDescription = "0 = line, + = curve to the 'right' from node 1 to node 2, - = curve left"
	float32 flCircleInvRadius;
	// MPropertyDescription = "path particle color"
	Color color;
};
