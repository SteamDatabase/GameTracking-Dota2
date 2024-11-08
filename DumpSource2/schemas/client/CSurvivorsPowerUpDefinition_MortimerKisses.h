class CSurvivorsPowerUpDefinition_MortimerKisses : public CSurvivorsPowerUpDefinition_AreaAttack_Circle
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sArtilleryParticle;
	float32 m_flMinRange;
	float32 m_flLaunchDistance;
	float32 m_flScepterLaunchDistance;
	float32 m_flAnglePerShot;
};
