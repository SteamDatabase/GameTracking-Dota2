// MGetKV3ClassDefaults = {
//	"m_unPickupID": 0,
//	"m_sPowerUpName": "",
//	"m_sParticleEffect": "",
//	"m_nModelIndex": 0,
//	"m_sDirectionalHelperParticle": "",
//	"m_sOnPickupOverheadEffect": "",
//	"m_nHealAmount": 0,
//	"m_nGoldAmount": 0,
//	"m_bRewardsTreasure": false,
//	"m_nTreasureVariant": 0,
//	"m_bShowInMinimap": false,
//	"m_sMinimapIconSnippet": "",
//	"m_bCanSpawnWithVelocity": false,
//	"m_flMaxSpawnVelocity": 0.000000,
//	"m_sDropSoundEvent": ""
//}
// MVDataRoot
class CSurvivorsPickupDefinition
{
	SurvivorsPickupID_t m_unPickupID;
	CUtlString m_sPowerUpName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticleEffect;
	int32 m_nModelIndex;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDirectionalHelperParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sOnPickupOverheadEffect;
	int32 m_nHealAmount;
	int32 m_nGoldAmount;
	bool m_bRewardsTreasure;
	int32 m_nTreasureVariant;
	bool m_bShowInMinimap;
	CUtlString m_sMinimapIconSnippet;
	bool m_bCanSpawnWithVelocity;
	float32 m_flMaxSpawnVelocity;
	CUtlString m_sDropSoundEvent;
};
