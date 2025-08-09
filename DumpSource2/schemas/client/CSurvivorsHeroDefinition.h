// MGetKV3ClassDefaults = {
//	"m_unHeroID": 0,
//	"m_nDOTAHeroID": 0,
//	"m_flBaseHealth": 100.000000,
//	"m_flBaseSpeed": 100.000000,
//	"m_flBasePickupRadius": 100.000000,
//	"m_flBaseDashSpeed": 1300.000000,
//	"m_flBaseDashDuration": 0.250000,
//	"m_flBaseDashCooldown": 1.000000,
//	"m_nBaseNumDashes": 1,
//	"m_flMass": 20000.000000,
//	"m_flCollisionRadius": 20.000000,
//	"m_flCollisionHeight": 100.000000,
//	"m_flTriggerCollisionRadiusPadding": 10.000000,
//	"m_pszPlayerHitSoundEvent": "",
//	"m_sLocDisplayName": "",
//	"m_vecEconItems":
//	[
//	],
//	"m_unStyleIndex": 255,
//	"m_vecBaseAttributes":
//	[
//	],
//	"m_vecStartingPowerUps":
//	[
//	],
//	"m_vecInnatePowerUps":
//	[
//	]
//}
// MVDataRoot
class CSurvivorsHeroDefinition
{
	SurvivorsHeroID_t m_unHeroID;
	HeroID_t m_nDOTAHeroID;
	float32 m_flBaseHealth;
	float32 m_flBaseSpeed;
	float32 m_flBasePickupRadius;
	float32 m_flBaseDashSpeed;
	float32 m_flBaseDashDuration;
	float32 m_flBaseDashCooldown;
	int32 m_nBaseNumDashes;
	float32 m_flMass;
	float32 m_flCollisionRadius;
	float32 m_flCollisionHeight;
	float32 m_flTriggerCollisionRadiusPadding;
	CUtlString m_pszPlayerHitSoundEvent;
	CUtlString m_sLocDisplayName;
	CUtlVector< item_definition_index_t > m_vecEconItems;
	style_index_t m_unStyleIndex;
	CUtlVector< CSurvivorsAttributeValue > m_vecBaseAttributes;
	CUtlVector< SurvivorsPowerUpID_t > m_vecStartingPowerUps;
	CUtlVector< SurvivorsPowerUpID_t > m_vecInnatePowerUps;
};
