class CDOTA_Ability_Invoker_Invoke : public CDOTABaseAbility
{
	int32 max_invoked_spells;
	CDOTA_Modifier_Invoker_Instance*[3] m_instances;
	int32 m_nCurInstanceSlot;
	bool m_bInvokedAbilitiesInitialized;
	CHandle< CBaseEntity >[10] m_invokedAbilities;
	Vector m_vecCurrentColor;
	int32 m_nQuasInstances;
	int32 m_nExortInstances;
	int32 m_nWexInstances;
}
