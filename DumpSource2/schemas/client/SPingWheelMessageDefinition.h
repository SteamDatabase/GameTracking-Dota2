// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class SPingWheelMessageDefinition
{
	// MPropertyDescription = "unique integer ID of this ping wheel message"
	// MVDataUniqueMonotonicInt = "_editor/next_ping_wheel_id"
	// MPropertyAttributeEditor = "locked_int()"
	PingWheelMessageID_t nID;
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
	// MPropertyDescription = "Multiplier to apply to 3 second base duration (dota_minimap_ping_duration)"
	float32 fDurationMultiplier;
	// MPropertyDescription = "Event for tracking expiration. See EEvent enum"
	EEvent eUnlockEvent;
	// MPropertyDescription = "Action of the unlock event which awards this ping wheel"
	uint32 nUnlockEventActionID;
	// MPropertyDescription = "ID of icon to show on minimap. See scripts/minimap_icons.txt"
	int32 nMinimapIcon;
};
