enum EArtyOrderFlag : uint32_t
{
	k_EArtyOrderFlag_None = 0,
	k_EArtyOrderFlag_MoveLeft = 1,
	k_EArtyOrderFlag_MoveRight = 2,
	k_EArtyOrderFlag_AimUp = 4,
	k_EArtyOrderFlag_AimDown = 8,
	k_EArtyOrderFlag_NextWeapon = 16,
	k_EArtyOrderFlag_PrevWeapon = 32,
	k_EArtyOrderFlag_FireStart = 64,
	k_EArtyOrderFlag_FireStop = 128,
	k_EArtyOrderFlag_FineControl = 256,
	k_EArtyOrderFlag_PowerUp = 512,
	k_EArtyOrderFlag_PowerDown = 1024,
	k_EArtyOrderFlag_MoveUp = 2048,
	k_EArtyOrderFlag_MoveDown = 4096,
};
