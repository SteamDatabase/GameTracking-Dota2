// MGetKV3ClassDefaults = {
//	"m_sParticleName": "",
//	"m_flDamage": 1.000000,
//	"m_flAttackCooldown": 1.000000,
//	"m_flSpeed": 50.000000,
//	"m_flRange": 1000.000000,
//	"m_flMaxDistance": 0.000000,
//	"m_flLifeTime": 0.000000,
//	"m_flAttackOffsetUp": 0.000000,
//	"m_flAttackOffsetForward": 0.000000,
//	"m_flRadius": 0.000000,
//	"m_activity": "ACT_DOTA_ATTACK",
//	"m_flAttackPoint": 0.000000,
//	"m_bHasIndicator": false,
//	"m_flSpawnDelay": 0.000000,
//	"m_eIndicatorShape": "k_eSurvivorsShape_Undefined"
//}
class CSurvivorsEnemyDefinition::Attack
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticleName;
	float32 m_flDamage;
	float32 m_flAttackCooldown;
	float32 m_flSpeed;
	float32 m_flRange;
	float32 m_flMaxDistance;
	float32 m_flLifeTime;
	float32 m_flAttackOffsetUp;
	float32 m_flAttackOffsetForward;
	float32 m_flRadius;
	GameActivity_t m_activity;
	float32 m_flAttackPoint;
	bool m_bHasIndicator;
	float32 m_flSpawnDelay;
	SurvivorsAttackIndicatorShape_t m_eIndicatorShape;
};
