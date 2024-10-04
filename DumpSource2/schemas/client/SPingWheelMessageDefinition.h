class SPingWheelMessageDefinition
{
	PingWheelMessageID_t nID;
	CUtlString sLocName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > sParticleTarget;
	Color color;
	CPanoramaImageName sImage;
	CUtlString sSound;
	CUtlString sChat;
	float32 fDurationMultiplier;
	EEvent eUnlockEvent;
	uint32 nUnlockEventActionID;
	int32 nMinimapIcon;
}
