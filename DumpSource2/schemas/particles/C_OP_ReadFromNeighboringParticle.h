class C_OP_ReadFromNeighboringParticle
{
	ParticleAttributeIndex_t m_nFieldInput;
	ParticleAttributeIndex_t m_nFieldOutput;
	int32 m_nIncrement;
	CPerParticleFloatInput m_DistanceCheck;
	CPerParticleFloatInput m_flInterpolation;
};
