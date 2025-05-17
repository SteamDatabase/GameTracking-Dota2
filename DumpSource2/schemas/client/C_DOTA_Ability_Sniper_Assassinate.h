class C_DOTA_Ability_Sniper_Assassinate : public C_DOTABaseAbility
{
	CHandle< C_BaseEntity > m_hTarget;
	ParticleIndex_t m_iIndex;
	float32 cooldown_reduction_on_kill;
};
