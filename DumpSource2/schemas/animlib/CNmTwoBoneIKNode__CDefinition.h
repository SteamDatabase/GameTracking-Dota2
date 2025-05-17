// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CNmTwoBoneIKNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	CGlobalSymbol m_effectorBoneID;
	int16 m_nEffectorTargetNodeIdx;
	int16 m_nEnabledNodeIdx;
	bool m_bIsTargetInWorldSpace;
};
