class C_DOTA_Ability_Razor_StaticLink : public C_DOTABaseAbility
{
	int32 m_iLinkIndex;
	CountdownTimer m_ViewerTimer;
	float32 vision_duration;
	bool m_bIsAltCastState;
};
