class CDOTA_Ability_Sniper_Assassinate : public CDOTABaseAbility
{
	CHandle< CBaseEntity > m_hTarget;
	ParticleIndex_t m_iIndex;
	float32 cooldown_reduction_on_kill;
};
