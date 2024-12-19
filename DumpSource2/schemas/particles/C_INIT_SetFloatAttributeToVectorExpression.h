class C_INIT_SetFloatAttributeToVectorExpression : public CParticleFunctionInitializer
{
	VectorFloatExpressionType_t m_nExpression;
	CPerParticleVecInput m_vInput1;
	CPerParticleVecInput m_vInput2;
	CParticleRemapFloatInput m_flOutputRemap;
	ParticleAttributeIndex_t m_nOutputField;
	ParticleSetMethod_t m_nSetMethod;
};
