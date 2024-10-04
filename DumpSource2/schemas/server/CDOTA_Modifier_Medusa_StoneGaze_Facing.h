class CDOTA_Modifier_Medusa_StoneGaze_Facing : public CDOTA_Buff
{
	float32 face_duration;
	float32 stone_duration;
	float32 duration;
	float32 vision_cone;
	float32 m_flAccumulatedTime;
	CountdownTimer ctFacing;
	bool m_bAlreadyStoned;
	ParticleIndex_t m_nFXIndex;
}
