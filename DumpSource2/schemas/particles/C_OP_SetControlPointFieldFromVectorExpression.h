class C_OP_SetControlPointFieldFromVectorExpression
{
	VectorFloatExpressionType_t m_nExpression;
	CParticleCollectionVecInput m_vecInput1;
	CParticleCollectionVecInput m_vecInput2;
	CPerParticleFloatInput m_flLerp;
	CParticleRemapFloatInput m_flOutputRemap;
	int32 m_nOutputCP;
	int32 m_nOutVectorField;
};
