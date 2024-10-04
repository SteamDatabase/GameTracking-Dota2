class CMaterialDrawDescriptor
{
	float32 m_flUvDensity;
	Vector m_vTintColor;
	float32 m_flAlpha;
	uint32 m_nFirstMeshlet;
	uint16 m_nNumMeshlets;
	RenderPrimitiveType_t m_nPrimitiveType;
	int32 m_nBaseVertex;
	int32 m_nVertexCount;
	int32 m_nStartIndex;
	int32 m_nIndexCount;
	CRenderBufferBinding m_indexBuffer;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_material;
}
