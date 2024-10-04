class CDOTA_Modifier_MuertaReleaseEvent_RemoveGravestone : public CDOTA_Buff
{
	ParticleIndex_t m_nParticleIndex;
	CUtlVector< ParticleIndex_t >* m_pActiveGravestones;
};
