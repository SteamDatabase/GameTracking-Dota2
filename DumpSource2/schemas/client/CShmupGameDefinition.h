// MGetKV3ClassDefaults = {
//	"m_flGameWidth": 1280.000000,
//	"m_flGameHeight": 720.000000,
//	"m_flBossFightDuration": 0.000000,
//	"m_nComboBaseScore": 100,
//	"m_player":
//	{
//		"m_nLives": 3,
//		"m_nFirstTimeBonusLives": 0,
//		"m_flModelScale": 1.000000,
//		"m_flShieldRadius": 10.000000,
//		"m_flHeartRadius": 1.000000,
//		"m_flMaxSpeed": 1.000000,
//		"m_flAccel": 1.000000,
//		"m_flAttackLaunchDistance": 1.000000,
//		"m_nModeSwapExtraAttackCooldown": 0,
//		"m_nModeSwapTicks": 0,
//		"m_nEnemyCollideDamage": 5,
//		"m_nFireAttackCooldown": 5,
//		"m_flFireAttackRadius": 1.000000,
//		"m_flFireAttackSpeed": 5.000000,
//		"m_nIceAttackCooldown": 5,
//		"m_flIceAttackRadius": 1.000000,
//		"m_flIceAttackSpeed": 5.000000,
//		"m_flSpecialAttackSpeed": 5.000000,
//		"m_nSpecialAttackDamage": 2,
//		"m_nSpecialAttackAbsorptionCost": 2,
//		"m_nSpecialAttackMax": 10,
//		"m_nTicksPerSpecialAttack": 1,
//		"m_nMaxBulletAbsorption": 20,
//		"m_flBulletSpread": 0.000000
//	},
//	"m_boss":
//	{
//		"m_vecBodyParts":
//		[
//		],
//		"m_flIntroDuration": 0.000000,
//		"m_flMouthLaserChargeTime": 0.000000,
//		"m_flMouthLaserDuration": 0.000000,
//		"m_flWingBarrageChargeTime": 0.000000,
//		"m_flWingBarrageDuration": 0.000000,
//		"m_nSplinterBlastCount": 1,
//		"m_fSplinterBlastChargeTime": 1.000000,
//		"m_flSplinterBlastDuration": 1.000000,
//		"m_flColdEmbraceDuration": 1.000000,
//		"m_vIdlePosition":
//		[
//			0.000000,
//			0.000000
//		]
//	}
//}
// MVDataRoot
class CShmupGameDefinition
{
	float32 m_flGameWidth;
	float32 m_flGameHeight;
	float32 m_flBossFightDuration;
	int32 m_nComboBaseScore;
	CShmupPlayerDefinition m_player;
	CShmupBossDefinition m_boss;
};
