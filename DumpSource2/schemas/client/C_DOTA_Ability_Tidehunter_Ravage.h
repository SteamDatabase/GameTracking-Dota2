class C_DOTA_Ability_Tidehunter_Ravage : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > m_hEntsHit;
	bool m_bAwardedKillEater;
	float32 duration;
}
