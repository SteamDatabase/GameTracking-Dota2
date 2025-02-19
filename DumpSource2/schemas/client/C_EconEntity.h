class C_EconEntity
{
	CAttributeContainer m_AttributeManager;
	bool m_bClientside;
	EconEntityParticleDisableMode_t m_nDisableMode;
	bool m_bParticleSystemsCreated;
	bool m_bForceDestroyAttachedParticlesImmediately;
	CUtlVector< C_EconEntity::AttachedParticleInfo_t > m_vecAttachedParticles;
	CHandle< CBaseAnimatingActivity > m_hViewmodelAttachment;
	int32 m_iOldTeam;
	bool m_bAttachmentDirty;
	style_index_t m_iOldStyle;
	CHandle< C_BaseEntity > m_hOldProvidee;
	CUtlVector< C_EconEntity::AttachedModelData_t > m_vecAttachedModels;
};
