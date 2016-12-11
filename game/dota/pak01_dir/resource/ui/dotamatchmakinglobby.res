//------------------------------------
// DOTA Matchmaking Dialog
//------------------------------------
"DOTAMatchmakingLobby.res"
{	
	controls
	{
		"DOTAMatchmakingLobby"
		{
			"ControlName"		"CDOTAMatchmakingLobby"
			"fieldName"		"DOTAMatchmakingLobby"
			"xpos"			"c-388"
			//"ypos"			"56"
			"wide"	 		"776"
			"tall"	 		"416"
			"zpos"			"21"
			"PaintBackground"	"0"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"768"
			"tall"				"416"
			style=GreyNoiseBackground
			MouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"0"
			"wide"				"752"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
			MouseInputEnabled=0
		}
		
		"listpanel_background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"768"
			"tall"				"451"
			"visible" "0"
			"bgcolor_override"	"19 19 19 255"
		}
		
		"FillWithBotsCheckButton"
		{
			"ControlName"		"CheckButton"
			"fieldName"		"FillWithBotsCheckButton"
			"xpos"		"195"
			"ypos"		"372"
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
			"xpos"		"225"
			"ypos"		"372"
			"wide"		"150"
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
			"xpos"		"385"
			"ypos"		"372"
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
			"xpos"		"415"
			"ypos"		"372"
			"wide"		"70"
			"tall"		"22"
			"zpos"		"6"
			"tabPosition"		"4"
			"labelText"		"#GameUI_Matchmaking_Enable_Cheats"
			"textAlignment"		"west"
			mouseinputenabled=false
			Style=StatLabel
		}
		
		"Back" //back button
		{
			"ControlName"		"Button"
			"fieldName"		"Back"
			"xpos"		"125"
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
			"Command"		"ClosePage"
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
		
		"GoodTeamLabel"
		{
			"ControlName"		"Label"
			"fieldName"		"GoodTeamLabel"
			"xpos"			"635"
			"ypos"			"22"
			"wide"			"125"
			"tall"			"20"
			"zpos"		"5"
			"visible"		"0"
			"enabled"		"1"
			"tabPosition"		"0"
			"labelText"		"GOOD GUYS"
			"textAlignment"		"center"
			"style"		"SectionTitle"
		}
		"GoodTeamImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"GoodTeamLabel"
			"xpos"			"624"
			"ypos"			"12"
			"wide"			"134"
			"tall"			"57"
			"zpos"		"5"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"0"
			scaleImage=1
			image="dashboard/good_team_header"
		}
		"GoodTeamLabelBG"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"GoodTeamLabelBG"
			"xpos"			"635"
			"ypos"			"22"
			"wide"			"179"
			"tall"			"76"
			"fillcolor"	"32 32 32 255"
			"zpos"	"4"
			"visible"		"0"
			"enabled"		"1"
			"pinCorner"		"0"
			"autoResize"		"3"
		}

		"listpanel_players_good"
		{
			"ControlName"		"PanelListPanel"
			"fieldName"		"listpanel_players_good"
			"xpos"			"625"
			"ypos"			"67"
			"wide"			"160"
			"tall"			"160"
			"zpos"		"5"
			"pinCorner"		"0"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"1"
			"showScrollBar"	"0"
			"bgcolor_override" "0 0 0 0"
		}
		
		"listpanel_background_good"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"listpanel_background_good"
			"xpos"		"635"
			"ypos"		"67"
			"wide"		"125"
			"tall"		"160"
			"zpos"		"4"
			"fillcolor"	"32 32 32 255"
			"zpos"	"-3"
			"visible"		"0"
			"enabled"		"1"
			"pinCorner"		"0"
			"autoResize"		"3"
		}

		"BadTeamImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"BadTeamImage"
			"xpos"			"624"
			"ypos"			"220"
			"wide"			"134"
			"tall"			"57"
			"zpos"		"5"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"0"
			scaleImage=1
			image="dashboard/bad_team_header"
		}
		"BadTeamLabel"
		{
			"ControlName"		"Label"
			"fieldName"		"BadTeamLabel"
			"xpos"			"626"
			"ypos"			"220"
			"wide"			"134"
			"tall"			"55"
			"zpos"		"6"
			"visible"		"0"
			"labelText"		"BAD GUYS"
			"textAlignment"		"south-west"
			"style"		"SectionTitle"
		}

		"BadTeamLabelBG"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"BadTeamLabelBG"
			"xpos"			"635"
			"ypos"			"228"
			"wide"			"125"
			"tall"			"20"
			"fillcolor"	"32 32 32 255"
			"zpos"	"4"
			"visible"		"0"
			"enabled"		"1"
			"pinCorner"		"0"
			"autoResize"		"3"
		}

		"listpanel_players_bad"
		{
			"ControlName"		"PanelListPanel"
			"fieldName"		"listpanel_players_bad"
			"xpos"			"625"
			"ypos"			"278"
			"wide"			"165"
			"tall"			"160"
			"zpos"		"5"
			"pinCorner"		"0"
			"visible"		"1"
			"enabled"		"1"
			"tabPosition"		"1"
			"showScrollBar"	"0"
			"bgcolor_override" "0 0 0 0"
		}
		
		"listpanel_background_bad"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"listpanel_background_bad"
			"xpos"		"635"
			"ypos"		"278"
			"wide"		"125"
			"tall"		"160"
			"fillcolor"	"32 32 32 255"
			"zpos"	"4"
			"visible"		"0"
			"enabled"		"1"
			"pinCorner"		"0"
			"autoResize"		"3"
		}

		"SwapTeams" //swap teams
		{
			"ControlName"		"Button"
			"fieldName"		"SwapTeams"
			"xpos"		"500"
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
		
		"mode_selector_combo"
		{
			"ControlName"	"ComboBox"
			"fieldName"		"mode_selector_combo"
			"xpos"			"15"
			"ypos"			"215"
			"wide"			"120"
			"tall"			"24"
			"enabled"		"1"
			"visible"		"0"
			"editable"		"0"
		}
		
		
		"maxplayers_text"
		{
			"ControlName"		"Label"
			"fieldName"		"maxplayers_text"
			"xpos"		"15"
			"ypos"		"242"
			"wide"		"120"
			"tall"		"20"
			"visible"		"0"
			"enabled"		"1"
			"tabPosition"		"0"
			"labelText"		"#GameUI_Matchmaker_Maxplayers"
			"textAlignment"		"west"
			"dulltext"		"0"
			"brighttext"		"0"
			"wrap"		"0"
			"fillcolor"	"255 255 255 255"
			"font"		"AchievementItemDescription"	//"defaultlarg"
		}
		
		"maxplayers_combo"
		{
			"ControlName"	"ComboBox"
			"fieldName"		"maxplayers_combo"
			"xpos"			"135"
			"ypos"			"242"
			"wide"			"50"
			"tall"			"24"
			"enabled"		"1"
			"visible"		"0"
			"editable"		"0"
		}	

		"LobbyChatHistory"
		{
			"ControlName"			"RichText"
			"fieldName"				"LobbyChatHistory"
			"xpos"		"12"
			"ypos"		"12"
			"wide"		"602"
			"tall"		"310"
			"wrap"					"1"
			"zpos"		"2"
			"autoResize"			"1"
			"pinCorner"				"1"
			"visible"				"1"
			"enabled"				"1"
			"labelText"				""
			"textAlignment"			"south-west"
	//		"font"					"ChatFont"
	//		"maxchars"				"-1"
			"bgcolor_override"     	"30 29 29 255"
		}

		"ChatInputLine"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"ChatInputLine"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"		    	"14"
			"ypos"			"328"
			"zpos"			"51"
			"wide"	 		"598"
			"tall"	 		"16"
			"bgcolor_override"     	"30 29 29 0"
		}
		"ChatInputBg"
		{
			"ControlName"		"Panel"
			"fieldName" 		"ChatInputBg"
			"visible" 		"1"
			"enabled" 		"1"                             
			"xpos"		    	"12"
			"ypos"			"326"
			"zpos"			"49"
			"wide"	 		"602"
			"tall"	 		"20"
			"bgcolor_override"     	"30 29 29 255"
			"mouseinputenabled" "0"
		}
	}
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		"ChatPromptColor" "255 255 255 255"
		"ChatPromptBGColor" "0 255 0 255"
	}
	styles
	{
		Label
		{
			textcolor=ChatPromptColor
			render_bg=none
		}
	}
}