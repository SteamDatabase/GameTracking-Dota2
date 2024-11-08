class CSurvivorsSpawnerEliteTurret : public CSurvivorsSpawner
{
	int32 m_nRoomIndex;
	int32 m_nEnemiesSpawnedCount;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sInvulnerableParticle;
	CUtlString m_sInvulnerableSkinName;
};
