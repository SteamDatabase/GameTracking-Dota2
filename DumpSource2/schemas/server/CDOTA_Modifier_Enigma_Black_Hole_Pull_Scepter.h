class CDOTA_Modifier_Enigma_Black_Hole_Pull_Scepter : public CDOTA_Buff
{
	int32 scepter_drag_speed;
	float32 scepter_pull_rotate_speed;
	float32 aura_origin_x;
	float32 aura_origin_y;
	ParticleIndex_t m_nFXIndex;
	Vector m_vCenter;
	GameTime_t m_flLastThinkTime;
}
