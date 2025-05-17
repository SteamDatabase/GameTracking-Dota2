// MNetworkVarNames = "Vector m_stolenAbilityColorHSV1"
// MNetworkVarNames = "Vector m_stolenAbilityColorHSV2"
// MNetworkVarNames = "Vector m_stolenAbilityFXColorHSV"
class CDOTA_Unit_Hero_Rubick : public CDOTA_BaseNPC_Hero
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnAbilityColorChanged"
	Vector m_stolenAbilityColorHSV1;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnAbilityColorChanged"
	Vector m_stolenAbilityColorHSV2;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnAbilityColorChanged"
	Vector m_stolenAbilityFXColorHSV;
	bool m_bHasInitializedAbilityColors;
};
