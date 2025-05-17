class CDOTA_Ability_Lamp_Use : public C_DOTABaseAbility
{
	GameTime_t m_flLastCaptureTime;
	CHandle< C_DOTA_BaseNPC > m_hTarget;
	ParticleIndex_t m_nChannelFXIndex;
};
