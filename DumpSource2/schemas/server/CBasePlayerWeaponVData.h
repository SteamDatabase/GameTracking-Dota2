class CBasePlayerWeaponVData
{
	CUtlString m_szClassName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_szWorldModel;
	bool m_bBuiltRightHanded;
	bool m_bAllowFlipping;
	CUtlString m_sMuzzleAttachment;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_szMuzzleFlashParticle;
	ItemFlagTypes_t m_iFlags;
	AmmoIndex_t m_nPrimaryAmmoType;
	AmmoIndex_t m_nSecondaryAmmoType;
	int32 m_iMaxClip1;
	int32 m_iMaxClip2;
	int32 m_iDefaultClip1;
	int32 m_iDefaultClip2;
	int32 m_iWeight;
	bool m_bAutoSwitchTo;
	bool m_bAutoSwitchFrom;
	RumbleEffect_t m_iRumbleEffect;
	bool m_bLinkedCooldowns;
	bool m_bReserveAmmoAsClips;
	CUtlOrderedMap< WeaponSound_t, CSoundEventName > m_aShootSounds;
	int32 m_iSlot;
	int32 m_iPosition;
}
