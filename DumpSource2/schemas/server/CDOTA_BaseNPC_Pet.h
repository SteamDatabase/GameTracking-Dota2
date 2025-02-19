class CDOTA_BaseNPC_Pet
{
	CHandle< CDOTA_BaseNPC_Hero > m_hHeroHandle;
	float32 m_flPetThreatLevel;
	bool m_bReadyToPerformCoopTeleport;
	bool m_bSupportsCoopTeleport;
	PetCoopStates_t m_nCoopState;
	CUtlString m_strPickupItemModel;
	CHandle< CDOTA_Pet_CarriedItem > m_hCarriedItem;
	int32 m_nPetLevel;
	PetLevelup_Rule_t m_nLevelupRule;
	int32 m_nXPCompendiumEventID;
};
