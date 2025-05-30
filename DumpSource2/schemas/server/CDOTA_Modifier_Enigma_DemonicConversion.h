class CDOTA_Modifier_Enigma_DemonicConversion : public CDOTA_Modifier_Kill
{
	int32 m_iAttackCount;
	int32 split_attack_count;
	float32 life_extension;
	int32 eidolon_attack_range;
	int32 eidolon_bonus_damage;
	int32 eidolon_bonus_attack_speed;
	bool m_bAllowSplit;
	int32 m_nSpawnNum;
	CHandle< CDOTA_BaseNPC > attack_target;
};
