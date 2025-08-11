// MGetKV3ClassDefaults = {
//	"m_nActionID": 633704640,
//	"m_strCustomActionName": "",
//	"m_pszSequenceName": "",
//	"m_pszIconFile": "",
//	"m_pszSwingSound": "",
//	"m_pszHitSound": "",
//	"m_nDuration": -1,
//	"m_HurtBox":
//	{
//		"m_vMinBounds":
//		[
//			0.000000,
//			0.000000,
//			0.000000
//		],
//		"m_vMaxBounds":
//		[
//			0.000000,
//			0.000000,
//			0.000000
//		]
//	},
//	"m_HitBox":
//	{
//		"m_vMinBounds":
//		[
//			0.000000,
//			0.000000,
//			0.000000
//		],
//		"m_vMaxBounds":
//		[
//			0.000000,
//			0.000000,
//			0.000000
//		]
//	},
//	"m_nHitBoxStart": -1,
//	"m_nHitBoxDuration": -1,
//	"m_nOnHitFrames": 0,
//	"m_nOnBlockFrames": 0,
//	"m_flGuardDamage": 0.000000,
//	"m_flChipDamage": 0.000000,
//	"m_flHitDamage": 0.000000,
//	"m_flHealOnDamage": 0.000000,
//	"m_healOnDamageParticle": "",
//	"m_nDashStart": -1,
//	"m_nDashDuration": -1,
//	"m_nDamageAmpFrames": 0,
//	"m_fDamageAmpPercent": 0.000000,
//	"m_damageAmpParticle": "",
//	"m_flPushbackOnHit": 0.000000,
//	"m_flPushbackOnBlock": 0.000000,
//	"m_projectileParticle": "",
//	"m_flProjectileSpeed": 0.000000,
//	"m_flProjectileRange": 0.000000,
//	"m_flDashSpeedMultiplier": 1.000000,
//	"m_installParticle": "",
//	"m_nInstallStart": 0,
//	"m_nInstallFrames": -1,
//	"m_actionParticle": "",
//	"m_vActionParticleOffset":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_nActionParticleStart": -1,
//	"m_nHitStop": 0,
//	"m_nBlockStop": 0,
//	"m_nInvulnerabilityFlags": "",
//	"m_nInvulnerabilityStart": -1,
//	"m_nInvulnerabilityDuration": -1,
//	"m_vCameraShakeScale":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_bSingleUse": false,
//	"m_bNoAttackerPushback": false,
//	"m_bIsSpecialMove": false,
//	"m_vecCancelOptions":
//	[
//	]
//}
// MVDataRoot
class CDOTAFightingGameActionDefinition
{
	EFightingGameActionID m_nActionID;
	CUtlString m_strCustomActionName;
	CUtlString m_pszSequenceName;
	CUtlString m_pszIconFile;
	CUtlString m_pszSwingSound;
	CUtlString m_pszHitSound;
	int32 m_nDuration;
	AABB_t m_HurtBox;
	AABB_t m_HitBox;
	int32 m_nHitBoxStart;
	int32 m_nHitBoxDuration;
	int32 m_nOnHitFrames;
	int32 m_nOnBlockFrames;
	float32 m_flGuardDamage;
	float32 m_flChipDamage;
	float32 m_flHitDamage;
	float32 m_flHealOnDamage;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_healOnDamageParticle;
	int32 m_nDashStart;
	int32 m_nDashDuration;
	int32 m_nDamageAmpFrames;
	float32 m_fDamageAmpPercent;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_damageAmpParticle;
	float32 m_flPushbackOnHit;
	float32 m_flPushbackOnBlock;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_projectileParticle;
	float32 m_flProjectileSpeed;
	float32 m_flProjectileRange;
	float32 m_flDashSpeedMultiplier;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_installParticle;
	int32 m_nInstallStart;
	int32 m_nInstallFrames;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_actionParticle;
	Vector2D m_vActionParticleOffset;
	int32 m_nActionParticleStart;
	int32 m_nHitStop;
	int32 m_nBlockStop;
	EFightingGameInvulnerabilityFlags m_nInvulnerabilityFlags;
	int32 m_nInvulnerabilityStart;
	int32 m_nInvulnerabilityDuration;
	Vector2D m_vCameraShakeScale;
	bool m_bSingleUse;
	bool m_bNoAttackerPushback;
	bool m_bIsSpecialMove;
	CUtlVector< CDOTAFightingGameCancelOptionDefinition > m_vecCancelOptions;
};
