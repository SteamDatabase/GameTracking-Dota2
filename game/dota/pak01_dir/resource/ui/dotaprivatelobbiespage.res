//------------------------------------
// DOTA Matchmaking Dialog
//------------------------------------
"DOTAMatchmakingDialog.res"
{	
	controls
	{
		"DOTAPrivateLobbiesPage"
		{
			"ControlName"		"CDOTAPrivateLobbiesPage"
			"fieldName"		"DOTAPrivateLobbiesPage"
			"ypos"			"0"
			"wide"	 		"512"
			"tall"	 		"416"
			"zpos"			"1"
			"PaintBackground"	"0"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
	
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"-2"
			"wide"				"512"
			"tall"				"416"
			style=GreyNoiseBackground
			mouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"-1"
			"wide"				"496"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
	
		"Back" //back button
		{
			"ControlName"		"Button"
			"fieldName"		"Back"
			"xpos"		"314"
			"ypos"		"368"
			"wide"		"70"
			"tall"		"24"
			"autoResize"		"0"
			"pinCorner"		"3"
			"visible"		"0"
			"enabled"		"1"
			"tabPosition"		"4"
			"labelText"		"#GameUI_Back"
			"textAlignment"		"west"
			"dulltext"		"0"
			"brighttext"		"0"
			"wrap"		"0"
			"Command"		"Close"
			"Default"		"0"
		}
		
		"Lobby" //lobby button
		{
			"ControlName"		"Button"
			"fieldName"		"Lobby"
			"xpos"		"90"
			"ypos"		"360"
			"wide"		"100"
			"tall"		"24"
			"labelText"		"CREATE LOBBY"	// TOdo: Localize
			"textAlignment"		"center"
			"Command"		"CreateLobby"
			style=RoundedButton
			visible=0
		}
		
		"PlayAIButton" //lobby button
		{
			"ControlName"		"Button"
			"fieldName"		"Lobby"
			"xpos"		"320"
			"ypos"		"360"
			"wide"		"150"
			"tall"		"24"
			"labelText"		"PLAY AGAINST THE A.I."	// TOdo: Localize
			"textAlignment"		"center"
			"Command"		"PlayAIButton"
			style=RoundedButton
			visible=0
		}
		
// 		"listpanel_games"
// 		{
// 			"ControlName"		"PanelListPanel"
// 			"fieldName"		"listpanel_games"
// 			"xpos"		"90"
// 			"ypos"		"40"
// 			"wide"		"390"
// 			"tall"		"300"
// 			"zpos"		"3"
// 		}

		"LobbyListLabel" { ControlName=Label fieldName=LobbyListLabel xpos=70 ypos=24 wide=380 tall=16 style=DashboardTitle labelText="LOBBY LIST" textAlignment=center minimum-width=112 }	// TODO:Localize
		
		"listpanel_background"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"listpanel_background"
			"xpos"		"15"
			"ypos"		"40"
			"wide"		"370"
			"tall"		"324"
			"fillcolor"	"32 32 32 255"
			"zpos"		"2"
			"zpos"	"-3"
			"visible"		"0"
			"enabled"		"1"
			"pinCorner"		"0"
			"autoResize"		"3"
		}
	}
	include="resource/UI/dashboard_style.res"
}