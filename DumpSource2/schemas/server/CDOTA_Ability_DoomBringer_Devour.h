class CDOTA_Ability_DoomBringer_Devour : public CDOTABaseAbility
{
	bool m_bIsAltCastState;
	int32 ability_bonus_level;
	CUtlVector< CHandle< CDOTABaseAbility > > m_vecAbilityDraftStolenAbilities;
};
