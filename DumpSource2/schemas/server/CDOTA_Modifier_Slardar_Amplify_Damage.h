class CDOTA_Modifier_Slardar_Amplify_Damage
{
	int32 armor_reduction;
	float32 scepter_delay;
	int32 undispellable;
	float32 puddle_radius;
	float32 puddle_duration;
	Vector m_vecLastPuddle;
	CHandle< CBaseEntity > m_hPuddle;
	int32 m_nSelfBuffSerialNumber;
};
