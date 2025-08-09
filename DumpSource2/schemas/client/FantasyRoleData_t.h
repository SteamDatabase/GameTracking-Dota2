// MGetKV3ClassDefaults = {
//	"m_eRole": "FANTASY_ROLE_UNDEFINED",
//	"m_vecPlayers":
//	[
//	]
//}
// MPropertyAutoExpandSelf
class FantasyRoleData_t
{
	// MPropertyDescription = "What role are these players for"
	Fantasy_Roles m_eRole;
	// MPropertyDescription = "List of Pro Players for the role"
	CUtlVector< FantasyPlayerData_t > m_vecPlayers;
};
