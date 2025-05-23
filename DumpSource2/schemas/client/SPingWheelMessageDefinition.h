// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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
