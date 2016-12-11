"Resource/UI/DOTAPersonaPanel.res"
{
	controls
	{
		"DOTAPersonaPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAPersonaPanel"
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
			MouseInputEnabled=0
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
			MouseInputEnabled=0
		}
		
		"TitleBar"
		{
			"ControlName"			"ImagePanel"
			"fieldName"			"TitleBar"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"576"
			"tall"				"24"

			"visible"			"0"
			"scaleImage"			"1"
			//"image"			
			"fillcolor"			"21 21 21 255"
		}
		
		"Title"
		{
			"ControlName"			"Label"
			"fieldName"			"Title"
			"visible"			"0"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"576"
			"tall"				"24"
			"textAlignment"		"center"
			
			"labelText"			"#dota_persona_panel_title"
			"style"				"DashboardTitle"
		}
		
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"450"
			"ypos"				"380"
			"zpos"				"2"
			"wide"				"70"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"#dota_match_history_back"
			"command"			"ClosePage"
		}
		
		"Avatar"
		{
			"ControlName"		"CAvatarImagePanel"
			"fieldName"		"Avatar"
			"xpos"			"14"
			"ypos"			"37"
			"wide"			"48"
			"tall"			"48"
			"scaleImage"		"1"
			"autoResize"		"0"
			"pinCorner"		"0"
			"fgcolor_override" 	"255 255 255 255"
			"drawcolor_override" 	"255 255 255 255"
			"alpha"			"255"
			"zpos"			"3"
			"group"				"PersonaDetails"
		}

		"PlayerName"
		{
			"ControlName"			"Label"
			"fieldName"			"PlayerName"
			"xpos"				"67"
			"ypos"				"37"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%playername%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"WinCountTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"WinCountTitle"
			"xpos"				"14"
			"ypos"				"100"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"#dota_profile_wins"
			"auto_wide_tocontents"		"1"
			"style"				"StatLabel"
			"group"				"PersonaDetails"
		}
		"LossCountTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"LossCountTitle"
			"xpos"				"14"
			"ypos"				"115"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"#dota_profile_losses"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"KarmaTitle"
		{
			"ControlName"		"Label"
			"fieldName"			"KarmaTitle"
			"xpos"				"300"
			"ypos"				"100"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"		"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"#dota_persona_karma"
			"group"				"PersonaDetails"
		}
		"RankTitle"
		{
			"ControlName"		"Label"
			"fieldName"			"RankTitle"
			"xpos"				"300"
			"ypos"				"115"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"		"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"#dota_persona_rank"
			"group"				"PersonaDetails"
		}
		"WinCountLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"WinCountLabel"
			"xpos"				"74"
			"ypos"				"100"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%wincount%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"LossCountLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"LossCountLabel"
			"xpos"				"74"
			"ypos"				"115"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%losscount%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"KarmaLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"KarmaLabel"
			"xpos"				"360"
			"ypos"				"100"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%karma%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"RankLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"RankLabel"
			"xpos"				"360"
			"ypos"				"115"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%rank%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"MostPlayedTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"MostPlayedTitle"
			"xpos"				"14"
			"ypos"				"150"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"style"				"SectionTitle"			
			"auto_wide_tocontents"		"1"
			"labelText"			"HEROES PLAYED"
			"group"				"PersonaDetails"
		}
		"MostPlayedWinsTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"MostPlayedWinsTitle"
			"xpos"				"140"
			"ypos"				"150"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"WINS"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		"MostPlayedLossesTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"MostPlayedLossesTitle"
			"xpos"				"180"
			"ypos"				"150"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"LOSSES"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		// top 3 played heroes
		"TopHeroName0"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroName0"
			"xpos"				"14"
			"ypos"				"170"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"%TopHeroName0%"
			"group"				"PersonaDetails"
		}
		"TopHeroWins0"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroWins0"
			"xpos"				"140"
			"ypos"				"170"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%topherowins0%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"TopHeroLosses0"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroLosses0"
			"xpos"				"180"
			"ypos"				"170"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%topherolosses0%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		// ==
		"TopHeroName1"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroName1"
			"xpos"				"14"
			"ypos"				"185"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"%TopHeroName1%"
			"group"				"PersonaDetails"
		}
		"TopHeroWins1"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroWins1"
			"xpos"				"140"
			"ypos"				"185"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%topherowins1%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"TopHeroLosses1"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroLosses1"
			"xpos"				"180"
			"ypos"				"185"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%topherolosses1%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		// ==
		"TopHeroName2"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroName2"
			"xpos"				"14"
			"ypos"				"200"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"%TopHeroName2%"
			"group"				"PersonaDetails"
		}
		"TopHeroWins2"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroWins2"
			"xpos"				"140"
			"ypos"				"200"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%topherowins2%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"TopHeroLosses2"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroLosses2"
			"xpos"				"180"
			"ypos"				"200"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%topherolosses2%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}		
		"MoreHeroesButton" { ControlName=Button fieldName=MoreHeroesButton xpos=14 ypos=215 wide=100 tall=15 command="MoreHeroesButton" labelText="more..." textinsetx=0 textinsety=0 auto_wide_tocontents=1 }		// TODO: localize		
				
		//===
		"RecentMatchesTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"RecentMatchesTitle"
			"xpos"				"14"
			"ypos"				"260"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"RECENT MATCHES"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		"HistoryListEntry0"
		{
			"ControlName"		"Panel"
			"fieldName"			"HistoryListEntry0"
			"wide"	 		"556"
			"tall"	 		"24"
			"zpos"			"2"	
			"bgcolor_override" "0 0 0 0"
		}
		"HistoryListEntry1"
		{
			"ControlName"		"Panel"
			"fieldName"			"HistoryListEntry1"
			"wide"	 		"556"
			"tall"	 		"24"
			"zpos"			"2"	
			"bgcolor_override" "0 0 0 0"
		}
		"HistoryListEntry2"
		{
			"ControlName"		"Panel"
			"fieldName"			"HistoryListEntry2"
			"wide"	 		"556"
			"tall"	 		"24"
			"zpos"			"2"
			"bgcolor_override" "0 0 0 0"
		}
		"MoreMatchHistoryButton" { ControlName=Button fieldName=MoreMatchHistoryButton xpos=14 ypos=350 wide=100 tall=15 command="MoreMatchHistoryButton" labelText="more..." textinsetx=0 textinsety=0 auto_wide_tocontents=1 }		// TODO: localize
		
		// achievement showcase
		"AchievementShowcaseTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"RecentMatchesTitle"
			"xpos"				"300"
			"ypos"				"150"
			"zpos"				"3"
			"wide"				"200"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"ACHIEVEMENT SHOWCASE"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		"AchievementShowcaseBG0" { ControlName=Panel fieldName=AchievementShowcaseBG0 wide=48 tall=48 zpos=2 style=AchievementStyle group=PersonaDetails }
		"AchievementShowcaseBG1" { ControlName=Panel fieldName=AchievementShowcaseBG1 wide=48 tall=48 zpos=2 style=AchievementStyle group=PersonaDetails }
		"AchievementShowcaseBG2" { ControlName=Panel fieldName=AchievementShowcaseBG2 wide=48 tall=48 zpos=2 style=AchievementStyle group=PersonaDetails }
		
		"AchievementImage0" { ControlName=ImagePanel fieldName=AchievementImage0 wide=48 tall=48 zpos=3 group=PersonaDetails scaleImage=1 }
		"AchievementImage1" { ControlName=ImagePanel fieldName=AchievementImage1 wide=48 tall=48 zpos=3 group=PersonaDetails scaleImage=1 }
		"AchievementImage2" { ControlName=ImagePanel fieldName=AchievementImage2 wide=48 tall=48 zpos=3 group=PersonaDetails scaleImage=1 }
		
		"MoreAchievementsButton" { ControlName=Button fieldName=MoreAchievementsButton xpos=300 ypos=215 wide=100 tall=15 command="MoreAchievementsButton" labelText="more..." textinsetx=0 textinsety=0 auto_wide_tocontents=1 }		// TODO: localize		
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		AchievementBG="40 40 40 255"
	}
	
	styles
	{
		"AchievementStyle"
		{
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 7, AchievementBG )"
			}
		}
	}
	
	layout
	{
		region { name=RecentMatchesRegion x=14 y=275 width=556 }
		region { name=AchievementShowcaseRegion x=300 y=165 width=300 }
		place { region=RecentMatchesRegion controls=HistoryListEntry0,HistoryListEntry1,HistoryListEntry2 dir=down spacing=0 }
		place { region=AchievementShowcaseRegion controls=AchievementShowcaseBG0,AchievementShowcaseBG1,AchievementShowcaseBG2 dir=right spacing=4 }
		place { region=AchievementShowcaseRegion controls=AchievementImage0,AchievementImage1,AchievementImage2 dir=right spacing=4 }
	}
}
