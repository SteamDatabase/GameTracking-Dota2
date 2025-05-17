// MNetworkVarNames = "EHANDLE m_hGripTarget"
class CDOTA_Ability_Bane_FiendsGrip : public CDOTABaseAbility
{
	// MNetworkEnable
	CHandle< CBaseEntity > m_hGripTarget;
	int32 fiend_grip_damage;
};
