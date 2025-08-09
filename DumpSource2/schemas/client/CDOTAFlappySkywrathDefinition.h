// MGetKV3ClassDefaults = {
//	"strID": "",
//	"sLayoutPath": "",
//	"sMapFile": "",
//	"sMapLoopingFile": "",
//	"sMapBGFile": "",
//	"vecDifficulties":
//	[
//	],
//	"flMinimumSpeed": 100.000000,
//	"flGravity": -2000.000000,
//	"flJumpPower": 600.000000,
//	"flGlideAcceleration": -20.000000,
//	"flGlideFallSpeed": 0.250000,
//	"flDashDuration": 1.000000,
//	"flDashBoost": 50.000000,
//	"flDashSpeed": 200.000000,
//	"flDiveDuration": 0.500000,
//	"flDiveSpeed": 100.000000,
//	"flTrackDistance": 5120.000000,
//	"flCameraDistance": 3672.000000,
//	"vCameraOffset":
//	[
//		0.000000,
//		0.000000,
//		500.000000
//	],
//	"vCameraEdgeThresholds":
//	[
//		-400.000000,
//		0.000000
//	],
//	"flCameraAcceleration": 50.000000,
//	"vPlayerSize":
//	[
//		100.000000,
//		100.000000
//	],
//	"vPlayerVerticalBounds":
//	[
//		30.000000,
//		650.000000
//	],
//	"vObstacleVerticalBounds":
//	[
//		30.000000,
//		900.000000
//	],
//	"vObstacleHorizontalBounds":
//	[
//		-900.000000,
//		900.000000
//	],
//	"flTopOffsetToTip": -1060.000000,
//	"flBottomOffsetToTip": 764.000000,
//	"vecInputActions":
//	[
//	]
//}
// MVDataRoot
// MVDataSingleton
class CDOTAFlappySkywrathDefinition
{
	CUtlString strID;
	CUtlString sLayoutPath;
	CUtlString sMapFile;
	CUtlString sMapLoopingFile;
	CUtlString sMapBGFile;
	CUtlVector< CDOTAFlappySkywrathDifficulty > vecDifficulties;
	float32 flMinimumSpeed;
	float32 flGravity;
	float32 flJumpPower;
	float32 flGlideAcceleration;
	float32 flGlideFallSpeed;
	float32 flDashDuration;
	float32 flDashBoost;
	float32 flDashSpeed;
	float32 flDiveDuration;
	float32 flDiveSpeed;
	float32 flTrackDistance;
	float32 flCameraDistance;
	Vector vCameraOffset;
	Vector2D vCameraEdgeThresholds;
	float32 flCameraAcceleration;
	Vector2D vPlayerSize;
	Vector2D vPlayerVerticalBounds;
	Vector2D vObstacleVerticalBounds;
	Vector2D vObstacleHorizontalBounds;
	float32 flTopOffsetToTip;
	float32 flBottomOffsetToTip;
	CUtlVector< CDOTAFlappySkywrathInputAction > vecInputActions;
};
