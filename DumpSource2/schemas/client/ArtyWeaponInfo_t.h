// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_sWeaponLocName": "",
//	"m_sWeaponLocDesc": "",
//	"m_sWeaponSwapSound": "",
//	"m_sWeaponFireSound": "",
//	"m_sWeaponImage": "",
//	"m_bIsPlayerWeapon": false,
//	"m_strGraphicInfoName": "",
//	"m_weaponAttackActivity": "ACT_DOTA_ATTACK",
//	"m_flShotCreationTime": 0.000000,
//	"m_flDamage": 1.000000,
//	"m_flHitRadius": 8.000000,
//	"m_flTerrainCarveRadius": 40.000000,
//	"m_flDamageRadius": 0.000000,
//	"m_flLockedAngle": -1.000000,
//	"m_flLockedPower": -1.000000,
//	"m_flReloadTime": 2.000000,
//	"m_nSplitCount": 0,
//	"m_flSplitTime": -1.000000,
//	"m_flSplitRepeatTime": -1.000000,
//	"m_flSplitDispersion": 0.000000,
//	"m_bSplitAtTop": false,
//	"m_bZeroXOnSplit": false,
//	"m_bSplitRepeats": false,
//	"m_szSplitWeapon": "",
//	"m_flMaxSpeed": 1000.000000,
//	"m_flDragMult": 1.000000,
//	"m_flWindMult": 1.000000,
//	"m_bIsRay": false,
//	"m_flRangeMult": 1.000000,
//	"m_nInitialShotCount": 1,
//	"m_nInitialShotAngleDispersionPer": 0.000000,
//	"m_flManaCost": 0.000000,
//	"m_bDisabled": false,
//	"m_bBounces": false,
//	"m_bBounceOffTarget": true,
//	"m_flFuseTime": 0.000000,
//	"m_flBounceDrag": 0.700000,
//	"m_nMaxReloads": -1,
//	"m_flGravityMult": 1.000000,
//	"m_bProximityFuse": false,
//	"m_bUseHighArc": true,
//	"m_bCollides": true,
//	"m_bDirectAimAtTarget": false,
//	"m_nWeaponPoints": 0,
//	"m_nRayDigTimes": 0,
//	"m_bNoShootingWhileInAir": false,
//	"m_bListenForKeypress": false,
//	"m_vVelocityMultOnKeypress":
//	[
//		1.000000,
//		1.000000
//	],
//	"m_vVelocityOffsetOnKeypress":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_bShowTrajectory": false,
//	"m_vVelocityMultOnExplode":
//	[
//		1.000000,
//		1.000000
//	],
//	"m_vVelocityOffsetOnExplode":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_nExplodeTimes": 1,
//	"m_flRadiusChangePerExplode": 0.000000
//}
// MVDataRoot
class ArtyWeaponInfo_t
{
	ArtyWeaponID_t m_unID;
	CUtlString m_sWeaponLocName;
	CUtlString m_sWeaponLocDesc;
	CUtlString m_sWeaponSwapSound;
	CUtlString m_sWeaponFireSound;
	CPanoramaImageName m_sWeaponImage;
	bool m_bIsPlayerWeapon;
	// MPropertyCustomFGDType = "vdata_choice:scripts/events/crownfall/artillery_graphics.vdata"
	CUtlString m_strGraphicInfoName;
	GameActivity_t m_weaponAttackActivity;
	float32 m_flShotCreationTime;
	float32 m_flDamage;
	float32 m_flHitRadius;
	float32 m_flTerrainCarveRadius;
	float32 m_flDamageRadius;
	float32 m_flLockedAngle;
	float32 m_flLockedPower;
	float32 m_flReloadTime;
	int32 m_nSplitCount;
	float32 m_flSplitTime;
	float32 m_flSplitRepeatTime;
	float32 m_flSplitDispersion;
	bool m_bSplitAtTop;
	bool m_bZeroXOnSplit;
	bool m_bSplitRepeats;
	CUtlString m_szSplitWeapon;
	float32 m_flMaxSpeed;
	float32 m_flDragMult;
	float32 m_flWindMult;
	bool m_bIsRay;
	float32 m_flRangeMult;
	int32 m_nInitialShotCount;
	float32 m_nInitialShotAngleDispersionPer;
	float32 m_flManaCost;
	bool m_bDisabled;
	bool m_bBounces;
	bool m_bBounceOffTarget;
	float32 m_flFuseTime;
	float32 m_flBounceDrag;
	int32 m_nMaxReloads;
	float32 m_flGravityMult;
	bool m_bProximityFuse;
	bool m_bUseHighArc;
	bool m_bCollides;
	bool m_bDirectAimAtTarget;
	int32 m_nWeaponPoints;
	int32 m_nRayDigTimes;
	bool m_bNoShootingWhileInAir;
	bool m_bListenForKeypress;
	Vector2D m_vVelocityMultOnKeypress;
	Vector2D m_vVelocityOffsetOnKeypress;
	bool m_bShowTrajectory;
	Vector2D m_vVelocityMultOnExplode;
	Vector2D m_vVelocityOffsetOnExplode;
	int32 m_nExplodeTimes;
	float32 m_flRadiusChangePerExplode;
};
