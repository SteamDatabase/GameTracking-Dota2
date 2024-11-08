class CSurvivorsPowerUp_MortimerKisses : public CSurvivorsPowerUp_AreaAttack_Circle
{
	CUtlVector< float32 > m_vecQueuedAttackTimers;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sArtilleryParticle;
	float32 m_flMinRange;
	float32 m_flLaunchDistance;
	float32 m_flScepterLaunchDistance;
	float32 m_flAnglePerShot;
	SurvivorsParticleID_t m_unArtilleryParticleID;
};
