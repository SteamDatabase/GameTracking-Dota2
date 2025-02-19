class CDOTA_Modifier_Teleporting
{
	float32 m_fStartTime;
	char[4096] m_iszPortalLoopAppear;
	char[4096] m_iszPortalLoopDisappear;
	char[4096] m_iszHeroLoopAppear;
	char[4096] m_iszHeroLoopDisappear;
	bool m_bSkipTeleportAnim;
	bool m_bPlayingCoopAnim;
	bool m_bIsPlayingTauntGesture;
	float32 m_fChannelTime;
	Vector m_vStart;
	Vector m_vEnd;
};
