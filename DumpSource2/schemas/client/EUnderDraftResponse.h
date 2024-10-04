enum EUnderDraftResponse : uint32_t
{
	k_eInternalError = 0,
	k_eSuccess = 1,
	k_eNoGold = 2,
	k_eInvalidSlot = 3,
	k_eNoBenchSpace = 4,
	k_eNoTickets = 5,
	k_eEventNotOwned = 6,
	k_eInvalidReward = 7,
	k_eHasBigReward = 8,
	k_eNoGCConnection = 9,
	k_eTooBusy = 10,
	k_eCantRollBack = 11,
};
