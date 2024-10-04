enum EPurchaseHeroRelicResult : uint32_t
{
	k_EPurchaseHeroRelicResult_Success = 0,
	k_EPurchaseHeroRelicResult_FailedToSend = 1,
	k_EPurchaseHeroRelicResult_NotEnoughPoints = 2,
	k_EPurchaseHeroRelicResult_InternalServerError = 3,
	k_EPurchaseHeroRelicResult_PurchaseNotAllowed = 4,
	k_EPurchaseHeroRelicResult_InvalidRelic = 5,
	k_EPurchaseHeroRelicResult_AlreadyOwned = 6,
	k_EPurchaseHeroRelicResult_InvalidRarity = 7,
};
