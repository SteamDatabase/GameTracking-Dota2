enum EBingoAuditAction : uint32_t
{
	k_eBingoAuditAction_Invalid = 0,
	k_eBingoAuditAction_DevModifyTokens = 1,
	k_eBingoAuditAction_DevClearInventory = 2,
	k_eBingoAuditAction_DevRerollCard = 3,
	k_eBingoAuditAction_ShuffleCard = 4,
	k_eBingoAuditAction_RerollSquare = 5,
	k_eBingoAuditAction_UpgradeSquare = 6,
	k_eBingoAuditAction_ClaimRow = 7,
	k_eBingoAuditAction_EventActionTokenGrant = 8,
	k_eBingoAuditAction_SupportGrantTokens = 9,
	k_eBingoAuditAction_SupportStatThresholdFixup = 10,
};
