// MNetworkVarNames = "CAnimationLayer m_AnimOverlay"
class CBaseAnimatingOverlayController : public CBaseAnimatingController
{
	// MNetworkEnable
	// MNetworkUserGroup = "overlay_vars"
	// MNetworkChangeCallback = "OnOverlaysChanged2"
	CUtlVectorEmbeddedNetworkVar< CAnimationLayer > m_AnimOverlay;
};
