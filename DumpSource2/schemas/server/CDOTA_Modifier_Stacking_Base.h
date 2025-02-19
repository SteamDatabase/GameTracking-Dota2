class CDOTA_Modifier_Stacking_Base
{
	int32 max_stacks;
	bool destroy_on_zero_stacks;
	float32 sub_modifier_forced_duration;
	CUtlString m_szSubModifierName;
	KeyValues* m_pSubModifierKV;
};
