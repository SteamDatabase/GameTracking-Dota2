class CDOTA_Ability_Tidehunter_Ravage : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_hEntsHit;
	bool m_bAwardedKillEater;
	float32 duration;
};
