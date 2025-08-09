// MGetKV3ClassDefaults = {
//	"nID": 0,
//	"nAssociatedID": 4294967295,
//	"sLocName": "",
//	"sParticle": "",
//	"sParticleTarget": "",
//	"color":
//	[
//		0,
//		0,
//		0,
//		0
//	],
//	"sImage": "",
//	"sSound": "",
//	"sChat": "",
//	"sChatWithTarget": "",
//	"eUnlockEvent": "EVENT_ID_NONE",
//	"nUnlockEventActionID": 0,
//	"m_flMinimapDuration": 3.000000,
//	"m_bFlashTargetIcon": false,
//	"m_minimapIconInfo":
//	{
//		"m_nIconID": 0,
//		"m_flSize": 800.000000,
//		"m_bAlignBottom": false,
//		"m_bForceBaseIconWhite": false,
//		"m_flAnimStartSize": 10000.000000,
//		"m_flAnimThrobSize": 300.000000,
//		"m_flAnimThrobRate": 6.000000,
//		"m_flAnimIntroDuration": 0.300000,
//		"m_flAnimOutroDuration": 0.500000,
//		"m_eDrawCondition": "k_ePingMinimapDrawCondition_Always"
//	},
//	"m_vecAdditionalMinimapLayers":
//	[
//	],
//	"m_particleInfo":
//	{
//		"m_flDuration": 3.000000,
//		"m_flRadius": 1.000000,
//		"m_flVerticalOffset": 240.000000,
//		"m_flBonusVerticalOffsetFromTargetEntity": 0.000000,
//		"m_bShowDotaPlusBadge": false
//	},
//	"m_bRequiresDotaPlus": false,
//	"m_bIsBindable": true
//}
// MVDataRoot
class SPingWheelMessageDefinition
{
	// MPropertyDescription = "unique integer ID of this ping wheel message"
	// MVDataUniqueMonotonicInt = "_editor/next_ping_wheel_id"
	// MPropertyAttributeEditor = "locked_int()"
	PingWheelMessageID_t nID;
	// MPropertyDescription = "optional ID of associated message, like enemy/friendly wards"
	PingWheelMessageID_t nAssociatedID;
	// MPropertyDescription = "localization string ID for name of ping"
	CUtlString sLocName;
	// MPropertyDescription = "Particle system of ping effect"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > sParticle;
	// MPropertyDescription = "Particle system of ping effect when targetting an npc (optional)"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > sParticleTarget;
	// MPropertyDescription = "Color of ping effect. Leave default to use pinging player color."
	// MPropertyColorPlusAlpha
	Color color;
	// MPropertyDescription = "Image shown while customizing ping wheel"
	CPanoramaImageName sImage;
	// MPropertyDescription = "Sound played when pinging"
	// MPropertyCustomFGDType = "sound"
	CUtlString sSound;
	// MPropertyDescription = "localization string ID for chat message when pinging"
	CUtlString sChat;
	// MPropertyDescription = "localization string ID for chat message when pinging a target entity"
	CUtlString sChatWithTarget;
	// MPropertyDescription = "Event for tracking expiration. See EEvent enum"
	EEvent eUnlockEvent;
	// MPropertyDescription = "Action of the unlock event which awards this ping wheel"
	uint32 nUnlockEventActionID;
	// MPropertyDescription = "Duration to show a ping on the the minimap."
	float32 m_flMinimapDuration;
	// MPropertyDescription = "Whether or not to flash the pinged unit's icon."
	bool m_bFlashTargetIcon;
	PingMinimapIconInfo_t m_minimapIconInfo;
	// MPropertyDescription = "Optional additional layers."
	CUtlVector< PingMinimapIconLayerInfo_t > m_vecAdditionalMinimapLayers;
	PingParticleInfo_t m_particleInfo;
	bool m_bRequiresDotaPlus;
	bool m_bIsBindable;
};
