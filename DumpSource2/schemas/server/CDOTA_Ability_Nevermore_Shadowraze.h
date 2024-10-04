class CDOTA_Ability_Nevermore_Shadowraze : public CDOTABaseAbility
{
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	float32 cooldown_reduction_on_hero_hit;
	bool m_bReadyToSetCooldown;
}
