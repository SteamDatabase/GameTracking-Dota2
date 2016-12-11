"Resource/UI/DOTAPracticeLobbyPanel.res"
{
	controls
	{
		"DOTAPracticeLobbyPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAPracticeLobbyPanel"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"c-288"
			//"ypos"			"56"
			"wide"	 		"576"
			"tall"	 		"416"
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"568"
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
			"zpos"				"0"
			"wide"				"552"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"GoodTeamImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"GoodTeamLabel"
			"xpos"			"70"
			"ypos"			"40"
			"wide"			"200"
			"tall"			"60"
			"zpos"		"5"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"0"
			scaleImage=1
			image="dashboard/good_team_header"
		}
		
		"BadTeamImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"BadTeamImage"
			"xpos"			"300"
			"ypos"			"40"
			"wide"			"200"
			"tall"			"60"
			"zpos"		"5"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"0"
			scaleImage=1
			image="dashboard/bad_team_header"
		}
		
		"PlayerList0" { ControlName=PanelListPanel xpos=70 ypos=105 wide=200 tall=150 zpos=2 }
		"PlayerList1" { ControlName=PanelListPanel xpos=300 ypos=105 wide=200 tall=150 zpos=2 }
		
		"SwapTeams" //swap teams
		{
			"ControlName"		"Button"
			"fieldName"		"SwapTeams"
			"xpos"		"120"
			"ypos"		"370"
			"wide"		"115"
			"tall"		"28"
			"zpos"		"5"
			"autoResize"		"0"
			"pinCorner"		"3"
			"tabPosition"		"4"
			"labelText"		"SWAP TEAMS"
			"textAlignment"		"center"
			"Command"		"swapteam"
			Style=GreyButton14Style
		}
		
		"Back" //back button
		{
			"ControlName"		"Button"
			"fieldName"		"Back"
			"xpos"		"480"
			"ypos"		"370"
			"wide"		"70"
			"tall"		"28"
			"zpos"		"5"
			"autoResize"		"0"
			"pinCorner"		"3"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"4"
			"labelText"		"#GameUI_Matchmaking_Leave"
			"textAlignment"		"center"
			"dulltext"		"0"
			"brighttext"		"0"
			"wrap"		"0"
			"Command"		"leave"
			"Default"		"0"
			Style=GreyButton14Style
		}
		
		
		"Launch" //back button
		{
			"ControlName"		"Button"
			"fieldName"		"Launch"
			"xpos"		"15"
			"ypos"		"370"
			"wide"		"100"
			"tall"		"28"
			"zpos"		"5"
			"autoResize"		"0"
			"pinCorner"		"3"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"4"
			"labelText"		"#GameUI_Matchmaking_Launch"
			"textAlignment"		"center"
			"Command"		"LaunchGame"
			"allCaps"		"1"
			Style=GreyButton14Style
		}
		
		"FillWithBotsCheckButton"
		{
			"ControlName"		"CheckButton"
			"fieldName"		"FillWithBotsCheckButton"
			"xpos"		"11"
			"ypos"		"340"
			"wide"		"180"
			"tall"		"22"
			"zpos"		"5"
			"tabPosition"		"4"
			"labelText"		""
			"textAlignment"		"north-west"
			Style=CheckButtonStyle
		}
		
		"FillWithBotsLabel"
		{
			"ControlName"		"Label"
			"fieldName"		"FillWithBotsLabel"
			"xpos"		"41"
			"ypos"		"340"
			"wide"		"180"
			"tall"		"22"
			"zpos"		"6"
			"tabPosition"		"4"
			"labelText"		"#GameUI_Matchmaking_Fill_With_Bots"
			"textAlignment"		"west"
			mouseinputenabled=false
			Style=StatLabel
		}
		
		"EnableCheatsCheckButton"
		{
			"ControlName"		"CheckButton"
			"xpos"		"11"
			"ypos"		"315"
			"wide"		"100"
			"tall"		"22"
			"zpos"		"5"
			"tabPosition"		"4"
			"labelText"		""
			"textAlignment"		"north-west"
			Style=CheckButtonStyle
		}
		
		"EnableCheatsLabel"
		{
			"ControlName"		"Label"
			"xpos"		"41"
			"ypos"		"315"
			"wide"		"70"
			"tall"		"22"
			"zpos"		"6"
			"tabPosition"		"4"
			"labelText"		"#GameUI_Matchmaking_Enable_Cheats"
			"textAlignment"		"west"
			mouseinputenabled=false
			Style=StatLabel
		}
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
