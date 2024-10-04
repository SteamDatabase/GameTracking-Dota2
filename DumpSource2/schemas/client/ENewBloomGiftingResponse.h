enum ENewBloomGiftingResponse : uint32_t
{
	kENewBloomGifting_Success = 0,
	kENewBloomGifting_UnknownFailure = 1,
	kENewBloomGifting_MalformedRequest = 2,
	kENewBloomGifting_FeatureDisabled = 3,
	kENewBloomGifting_ItemNotFound = 4,
	kENewBloomGifting_PlayerNotAllowedToGiveGifts = 5,
	kENewBloomGifting_TargetNotAllowedToReceiveGifts = 6,
	kENewBloomGifting_ServerNotAuthorized = 100,
	kENewBloomGifting_PlayerNotInLobby = 101,
	kENewBloomGifting_TargetNotInLobby = 102,
	kENewBloomGifting_LobbyNotEligible = 103,
	kENewBloomGifting_TargetNotFriend = 200,
	kENewBloomGifting_TargetFriendDurationTooShort = 201,
};
