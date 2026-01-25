// MNetworkVarNames = "HMaterialStrong m_skyBoxFaces"
// MNetworkVarNames = "HRenderTextureStrong m_hHeightFogTexture"
// MNetworkVarNames = "HRenderTextureStrong m_hHeightFogMaskTexture"
class C_World : public C_BaseModelEntity
{
	// MNetworkEnable
	// MNotSaved
	CStrongHandle< InfoForResourceTypeIMaterial2 >[6] m_skyBoxFaces;
	// MNetworkEnable
	// MNotSaved
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hHeightFogTexture;
	// MNetworkEnable
	// MNotSaved
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hHeightFogMaskTexture;
};
