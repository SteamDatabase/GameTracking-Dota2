// MGetKV3ClassDefaults = {
//	"m_unOpponentID": 0,
//	"m_sLocName": "",
//	"m_sLocFlavor": "",
//	"m_sUnitName": "",
//	"m_sModelName": "",
//	"m_nHeroID": 0,
//	"m_vecHeroItems":
//	[
//	],
//	"m_nHeroPrimarySlotIndex": -1,
//	"m_nHeroModelIndex": 0,
//	"m_nHeroSkinOverride": -1,
//	"m_vModelOffset":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_flModelScale": -1.000000,
//	"m_flMaxHealth": 0.000000,
//	"m_sAttackParticleEffect": "",
//	"m_sAttackImpactSound": "",
//	"m_vecIntroActions":
//	[
//	],
//	"m_vecRepeatingActions":
//	[
//	],
//	"m_vecOutroActions":
//	[
//	]
//}
// MVDataRoot
class CMatch3OpponentDefinition
{
	Match3OpponentID_t m_unOpponentID;
	CUtlString m_sLocName;
	CUtlString m_sLocFlavor;
	CUtlString m_sUnitName;
	CUtlString m_sModelName;
	HeroID_t m_nHeroID;
	CUtlVector< CMatch3OpponentHeroItemDefinition > m_vecHeroItems;
	int32 m_nHeroPrimarySlotIndex;
	int32 m_nHeroModelIndex;
	int32 m_nHeroSkinOverride;
	Vector m_vModelOffset;
	float32 m_flModelScale;
	float32 m_flMaxHealth;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAttackParticleEffect;
	CUtlString m_sAttackImpactSound;
	CUtlVector< CMatch3OpponentActionInstanceDefinition > m_vecIntroActions;
	CUtlVector< CMatch3OpponentActionInstanceDefinition > m_vecRepeatingActions;
	CUtlVector< CMatch3OpponentActionInstanceDefinition > m_vecOutroActions;
};
