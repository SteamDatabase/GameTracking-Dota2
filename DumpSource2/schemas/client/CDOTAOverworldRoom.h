// MGetKV3ClassDefaults = {
//	"m_unRoomID": 0,
//	"m_vPos":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_vSize":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_vecNodes":
//	[
//	],
//	"m_unUnlockedByNodeID": 0
//}
// MVDataRoot
class CDOTAOverworldRoom
{
	OverworldRoomID_t m_unRoomID;
	// MPropertyDescription = "The left top of the Room, in 2d panel space."
	Vector2D m_vPos;
	// MPropertyDescription = "The width and height of the Room, in 2d panel space"
	Vector2D m_vSize;
	// MPropertyDescription = "The Node IDs that belong to this room."
	CUtlVector< OverworldNodeID_t > m_vecNodes;
	// MPropertyDescription = "This room becomes accessible when the given node is unlocked. If invalid, this room starts off accessible."
	OverworldNodeID_t m_unUnlockedByNodeID;
};
