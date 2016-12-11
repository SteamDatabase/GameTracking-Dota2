"Resource/UI/DOTAAchievementPanel.res"
{
	controls
	{
		"DOTAAchievementPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAAchievementPanel"
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
			"scaleImage"			"1"
			//"image"			
			"fillcolor"			"21 21 21 255"
			"visible"			"0"
		}
		
		"Title"
		{
			"ControlName"			"Label"
			"fieldName"			"Title"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"576"
			"tall"				"24"
			"textAlignment"		"center"
			"style"				"DashboardTitle"
			"labelText"			"ACHIEVEMENTS"
			"visible"			"0"
		}
		
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"450"
			"ypos"				"370"
			"zpos"				"2"
			"wide"				"70"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"#dota_match_history_back"
			"command"			"ClosePage"
		}
		
		// achievement showcase
		"AchievementShowcaseTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"RecentMatchesTitle"
			"xpos"				"220"
			"ypos"				"20"
			"zpos"				"3"
			"wide"				"152"
			"tall"				"15"

			"textAlignment"			"north"
			"auto_wide_tocontents"		"1"
			"labelText"			"SHOWCASE"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		"AchievementShowcaseBG0" { ControlName=Panel fieldName=AchievementShowcaseBG0 wide=48 tall=48 zpos=2 style=AchievementStyle group=AchievementShowcase }
		"AchievementShowcaseBG1" { ControlName=Panel fieldName=AchievementShowcaseBG1 wide=48 tall=48 zpos=2 style=AchievementStyle group=AchievementShowcase }
		"AchievementShowcaseBG2" { ControlName=Panel fieldName=AchievementShowcaseBG2 wide=48 tall=48 zpos=2 style=AchievementStyle group=AchievementShowcase }
		
		"AchievementImage0" { ControlName=ImagePanel fieldName=AchievementImage0 wide=48 tall=48 zpos=3 group=AchievementShowcase scaleImage=1 pin_to_sibling=AchievementShowcaseBG0 }
		"AchievementImage1" { ControlName=ImagePanel fieldName=AchievementImage1 wide=48 tall=48 zpos=3 group=AchievementShowcase scaleImage=1 pin_to_sibling=AchievementShowcaseBG1 }
		"AchievementImage2" { ControlName=ImagePanel fieldName=AchievementImage2 wide=48 tall=48 zpos=3 group=AchievementShowcase scaleImage=1 pin_to_sibling=AchievementShowcaseBG2 }

		"DraggingAchievement" { ControlName=ImagePanel fieldName=DraggingAchievement wide=48 tall=48 zpos=30 scaleImage=1 }
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
		include="resource/UI/dashboard_style.res"
	}	
	
	layout
	{
		region { name=AchievementShowcaseRegion x=220 y=35 width=300 }
		place { region=AchievementShowcaseRegion controls=AchievementShowcaseBG0,AchievementShowcaseBG1,AchievementShowcaseBG2 dir=right spacing=4 }
	}
}
