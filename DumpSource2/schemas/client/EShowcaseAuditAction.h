enum EShowcaseAuditAction : uint32_t
{
	k_eShowcaseAuditAction_Invalid = 0,
	k_eShowcaseAuditAction_ShowcaseChanged = 1,
	k_eShowcaseAuditAction_AdminShowcaseReset = 2,
	k_eShowcaseAuditAction_AdminShowcaseAccountLocked = 3,
	k_eShowcaseAuditAction_AdminShowcaseExonerated = 4,
	k_eShowcaseAuditAction_AdminShowcaseConvicted = 5,
	k_eShowcaseAuditAction_AdminModerationApproved = 6,
	k_eShowcaseAuditAction_AdminModerationRejected = 7,
};
