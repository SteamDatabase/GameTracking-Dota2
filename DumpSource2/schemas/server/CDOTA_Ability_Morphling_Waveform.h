class CDOTA_Ability_Morphling_Waveform : public CDOTABaseAbility
{
	int32 m_nProjectileID;
	Vector m_vProjectileLocation;
	CHandle< CBaseEntity > m_hHitHero;
	bool m_bGrantedGem;
};
