// MNetworkVarNames = "CAnimationLayer m_AnimOverlay"
class C_BaseAnimatingOverlayController : public C_BaseAnimatingController
{
	// MNetworkEnable
	// MNetworkUserGroup = "overlay_vars"
	// MNetworkChangeCallback = "OnOverlaysChanged2"
	C_UtlVectorEmbeddedNetworkVar< CAnimationLayer > m_AnimOverlay;
};
