class CDOTA_Modifier_Dazzle_NothlProjection_SoulClone : public CDOTA_Buff
{
	float32 shadow_wave_cdr;
	float32 healing_amp;
	GameTime_t m_flLastThinkTime;
	float32 leash_start;
	float32 base_leash_pull;
	float32 leash_increase;
	CHandle< CDOTA_BaseNPC > m_hBody;
};
