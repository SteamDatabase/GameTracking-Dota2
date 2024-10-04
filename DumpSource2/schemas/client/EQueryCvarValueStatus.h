enum EQueryCvarValueStatus : uint32_t
{
	eQueryCvarValueStatus_ValueIntact = 0,
	eQueryCvarValueStatus_CvarNotFound = 1,
	eQueryCvarValueStatus_NotACvar = 2,
	eQueryCvarValueStatus_CvarProtected = 3,
};
