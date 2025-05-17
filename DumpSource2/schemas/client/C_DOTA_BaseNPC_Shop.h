// MNetworkVarNames = "DOTA_SHOP_TYPE m_ShopType"
class C_DOTA_BaseNPC_Shop : public C_DOTA_BaseNPC_Building
{
	// MNetworkEnable
	DOTA_SHOP_TYPE m_ShopType;
	ParticleIndex_t m_nShopFX;
	Vector m_vShopFXOrigin;
	float32 m_flLastSpeech;
};
