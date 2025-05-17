class CDOTA_Item_Ward_Maker : public CDOTA_Item
{
	float32 sentry_refresh;
	int32 max_sentry_charges;
	GameTime_t m_flLastThinkTime;
	float32 m_flTimeAccumulator;
};
