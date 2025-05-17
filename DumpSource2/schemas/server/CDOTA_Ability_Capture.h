// MNetworkVarNames = "CHandle<CDOTA_BaseNPC> m_hTarget"
class CDOTA_Ability_Capture : public CDOTABaseAbility
{
	// MNetworkEnable
	CHandle< CDOTA_BaseNPC > m_hTarget;
	CDOTA_Buff* m_pMyBuff;
};
