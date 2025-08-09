// MGetKV3ClassDefaults = {
//	"m_nHeroID": 0,
//	"m_sPieceModel": "",
//	"m_sAttackParticleEffect": "",
//	"m_sSuperAbility": "",
//	"m_sUltraAbility": ""
//}
// MVDataRoot
class CMatch3HeroDefinition
{
	HeroID_t m_nHeroID;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sPieceModel;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAttackParticleEffect;
	CUtlString m_sSuperAbility;
	CUtlString m_sUltraAbility;
};
