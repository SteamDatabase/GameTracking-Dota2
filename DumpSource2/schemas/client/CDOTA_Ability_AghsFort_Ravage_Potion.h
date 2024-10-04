class CDOTA_Ability_AghsFort_Ravage_Potion : public C_DOTA_Item
{
	CUtlVector< CHandle< C_BaseEntity > > m_hEntsHit;
	int32 damage;
	float32 duration;
	float32 spend_charge_delay;
}
