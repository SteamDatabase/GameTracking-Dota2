class C_INIT_RemapNamedModelElementToScalar
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	CUtlVector< CUtlString > m_names;
	CUtlVector< float32 > m_values;
	ParticleAttributeIndex_t m_nFieldInput;
	ParticleAttributeIndex_t m_nFieldOutput;
	ParticleSetMethod_t m_nSetMethod;
	bool m_bModelFromRenderer;
};
