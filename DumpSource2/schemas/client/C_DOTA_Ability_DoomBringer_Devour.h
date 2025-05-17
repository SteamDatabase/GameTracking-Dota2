class C_DOTA_Ability_DoomBringer_Devour : public C_DOTABaseAbility
{
	bool m_bIsAltCastState;
	int32 ability_bonus_level;
	CUtlVector< CHandle< C_DOTABaseAbility > > m_vecAbilityDraftStolenAbilities;
};
