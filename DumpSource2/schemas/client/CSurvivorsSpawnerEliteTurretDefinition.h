class CSurvivorsSpawnerEliteTurretDefinition : public CSurvivorsSpawnerDefinition
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sInvulnerableParticle;
	CUtlString m_sInvulnerableSkinName;
};
