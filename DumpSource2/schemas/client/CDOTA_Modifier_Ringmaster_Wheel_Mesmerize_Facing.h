class CDOTA_Modifier_Ringmaster_Wheel_Mesmerize_Facing : public CDOTA_Buff
{
	float32 face_duration;
	float32 duration;
	float32 vision_cone;
	float32 m_flAccumulatedTime;
	float32 mesmerize_radius;
	CountdownTimer ctFacing;
	ParticleIndex_t m_nFXIndex;
};
