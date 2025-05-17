// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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
