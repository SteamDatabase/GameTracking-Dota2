// MNetworkVarNames = "CHandle<CDOTA_BaseNPC> m_hTarget"
class CDOTA_Ability_Capture : public C_DOTABaseAbility
{
	// MNetworkEnable
	CHandle< C_DOTA_BaseNPC > m_hTarget;
	CDOTA_Buff* m_pMyBuff;
};
