class C_OP_RenderGpuImplicit
{
	bool m_bUsePerParticleRadius;
	uint32 m_nVertexCountKb;
	uint32 m_nIndexCountKb;
	CParticleCollectionRendererFloatInput m_fGridSize;
	CParticleCollectionRendererFloatInput m_fRadiusScale;
	CParticleCollectionRendererFloatInput m_fIsosurfaceThreshold;
	int32 m_nScaleCP;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hMaterial;
};
