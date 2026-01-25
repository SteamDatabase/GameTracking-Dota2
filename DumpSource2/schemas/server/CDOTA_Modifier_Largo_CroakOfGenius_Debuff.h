class CDOTA_Modifier_Largo_CroakOfGenius_Debuff : public CDOTA_Buff
{
	float32 damage_portion_pct;
	float32 damage_per_second;
	float32 damage_hp_pct;
	float32 trigger_damage;
	float32 damage_duration;
	float32 m_flDamageInterval;
	CHandle< CBaseEntity > m_hTriggerCaster;
	CUtlVector< float32 > m_vecDamageTicks;
	bool m_bSpokeConcept;
};
