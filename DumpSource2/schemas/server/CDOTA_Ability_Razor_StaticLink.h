class CDOTA_Ability_Razor_StaticLink : public CDOTABaseAbility
{
	int32 m_iLinkIndex;
	CountdownTimer m_ViewerTimer;
	float32 vision_duration;
	bool m_bIsAltCastState;
}
