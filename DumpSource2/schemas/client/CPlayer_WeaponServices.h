class CPlayer_WeaponServices
{
	C_NetworkUtlVectorBase< CHandle< C_BasePlayerWeapon > > m_hMyWeapons;
	CHandle< C_BasePlayerWeapon > m_hActiveWeapon;
	CHandle< C_BasePlayerWeapon > m_hLastWeapon;
	uint16[32] m_iAmmo;
};
