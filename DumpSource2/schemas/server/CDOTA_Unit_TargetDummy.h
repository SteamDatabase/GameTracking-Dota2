class CDOTA_Unit_TargetDummy : public CDOTA_BaseNPC_Hero
{
	float32 m_flDamageTaken;
	float32 m_flLastHit;
	GameTime_t m_flStartDamageTime;
	GameTime_t m_flLastTargetDummyDamageTime;
}
