"Resource/UI/HUD_EndGame.res"
{
	controls
	{
		"HudDOTAGameEnd"
		{
			"ControlName"		"EditablePanel"
			"fieldName"			"HudDOTAGameEnd"
			"xpos"				"c-348"
			"ypos"				"100"
			"zpos"				"600"
			"wide"				"696"
			"tall"				"444"
			"bgcolor_override"	"0 0 0 0"
		}
		
		"HudDOTAGameEndBackground"
		{
			"ControlName"		"Panel"
			"fieldName"			"HudDOTAGameEndBackground"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"696"
			"tall"				"444"
			//"bgcolor_override"	"0 0 0 255"
			style=GradientBackground
		}
		
		"HudDOTAGameEndWinnerLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"HudDOTAGameEndWinnerLabel"
			"xpos"				"198"
			"ypos"				"20"
			"zpos"				"10"
			"wide"				"300"
			"tall"				"20"
			"textAlignment"		"center"
			"fgcolor_override"	"255 255 255 255"
			"bgcolor_override"	"26 26 26 255"
			"font"				"Arial18Thick"
		}
		"GoodGuysLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"GoodGuysLabel"
			"xpos"				"17"
			"ypos"				"55"
			"wide"				"180"
			"labelText"			"#DOTA_Scoreboard_GoodGuys"
			"font"				"Arial14Thick"
			"bgcolor_override"	"0 0 0 0"
			"zpos"				"5"
		}		
		"EndGameEntry0" { ControlName=EditablePanel fieldName=EndGameEntry0 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry1" { ControlName=EditablePanel fieldName=EndGameEntry1 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry2" { ControlName=EditablePanel fieldName=EndGameEntry2 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry3" { ControlName=EditablePanel fieldName=EndGameEntry3 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry4" { ControlName=EditablePanel fieldName=EndGameEntry4 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		
		"BadGuysLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"BadGuysLabel"
			"xpos"				"17"
			"ypos"				"220"
			"wide"				"180"
			"labelText"			"#DOTA_Scoreboard_BadGuys"
			"font"				"Arial14Thick"
			"bgcolor_override"	"0 0 0 0"
			"zpos"				"5"
		}		
		"EndGameEntry5" { ControlName=EditablePanel fieldName=EndGameEntry5 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry6" { ControlName=EditablePanel fieldName=EndGameEntry6 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry7" { ControlName=EditablePanel fieldName=EndGameEntry7 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry8" { ControlName=EditablePanel fieldName=EndGameEntry8 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		"EndGameEntry9" { ControlName=EditablePanel fieldName=EndGameEntry9 wide=666 tall=24 bgcolor_override="0 0 0 0" zpos=2 mouseinputenabled=1 }
		
		"DurationHeader" { ControlName=Label fieldName=DurationHeader xpos=632 ypos=15 wide=100 tall=24 style=ColumnHeader zpos=5 textAlignment=west labelText="DURATION" }
		"DurationLabel" { ControlName=Label fieldName=DurationLabel xpos=632 ypos=28 wide=100 tall=24 style=StatLabel zpos=5 textAlignment=west }
		
		// good guy headers
		HeroHeader { ControlName=Label fieldName=HeroHeader xpos=157 ypos=70 wide=150 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="HERO" }
		PlayerLabel { ControlName=Label fieldName=PlayerLabel xpos=22 ypos=70 wide=150 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="PLAYER" }
		LevelLabel { ControlName=Label fieldName=LevelLabel xpos=127 ypos=70 wide=27 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="LEVEL" }
		KDALabel { ControlName=Label fieldName=KDALabel xpos=289 ypos=70 wide=100 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="K/D/A" }
		ItemsHeader { ControlName=Label fieldName=ItemsHeader xpos=347 ypos=70 wide=27 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="ITEMS" }
		GoldLabel { ControlName=Label fieldName=GoldLabel xpos=462 ypos=70 wide=45 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="GOLD" }
		LastHitsLabel { ControlName=Label fieldName=LastHitsLabel xpos=500 ypos=70 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="LAST HITS" }
		DeniesLabel { ControlName=Label fieldName=DeniesLabel xpos=547 ypos=70 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="DENIES" }
		GoldPerMinuteLabel { ControlName=Label fieldName=GoldPerMinuteLabel xpos=592 ypos=70 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="GOLD/MIN" }
		XPPerMinuteLabel { ControlName=Label fieldName=XPPerMinuteLabel xpos=647 ypos=70 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="XP/MIN" }
		
		// bad guy headers
		HeroHeader2 { ControlName=Label fieldName=HeroHeader2 xpos=157 ypos=235 wide=150 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="HERO" }
		PlayerLabel2 { ControlName=Label fieldName=PlayerLabel2 xpos=22 ypos=235 wide=150 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="PLAYER" }
		LevelLabel2 { ControlName=Label fieldName=LevelLabel2 xpos=127 ypos=235 wide=27 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="LEVEL" }
		KDALabel2 { ControlName=Label fieldName=KDALabel2 xpos=289 ypos=235 wide=100 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="K/D/A" }
		ItemsHeader2 { ControlName=Label fieldName=ItemsHeader2 xpos=347 ypos=235 wide=27 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="ITEMS" }
		GoldLabel2 { ControlName=Label fieldName=GoldLabel2 xpos=462 ypos=235 wide=45 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="GOLD" }
		LastHitsLabel2 { ControlName=Label fieldName=LastHitsLabel2 xpos=500 ypos=235 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="LAST HITS" }
		DeniesLabel2 { ControlName=Label fieldName=DeniesLabel2 xpos=547 ypos=235 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="DENIES" }
		GoldPerMinuteLabel2 { ControlName=Label fieldName=GoldPerMinuteLabel2 xpos=592 ypos=235 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="GOLD/MIN" }
		XPPerMinuteLabel2 { ControlName=Label fieldName=XPPerMinuteLabel2 xpos=647 ypos=235 wide=50 tall=20 textAlignment=west style=ColumnHeader group=PlayerDetails labelText="XP/MIN" }
		
		"FinishGameButton" { ControlName=Button xpos=290 ypos=394 wide=140 tall=32 style=GreyButtonStyle zpos=3 mouseinputenabled=1 labelText="#DOTA_Finish_Game" textAlignment="center" command="disconnect" }
	}
	
	colors
	{
		"DashboardGradientTop"		"34 34 34 255"
		"DashboardGradientBottom"	"34 34 34 255"
		"dullwhite"					"200 200 200 255"
	}
	
	styles
	{
		"ColumnHeader"
		{
			textcolor=LighterGrey
			font=DefaultVeryTiny
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		GradientBackground
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, DashboardGradientTop, DashboardGradientBottom )"
			}
		}
		GreyButton14Style				{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButton14Style:hover			{ font=Arial14Thick textcolor=white bgcolor=none render_bg		{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButton14Style:active		{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		
		GreyButtonStyle				{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButtonStyle:hover		{ font=Arial18Thick textcolor=white bgcolor=none render_bg		{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButtonStyle:active		{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
	}
	
	layout
	{
		region { name=GoodGuysRegion x=17 y=90 width=656 }
		place { region=GoodGuysRegion controls=EndGameEntry0,EndGameEntry1,EndGameEntry2,EndGameEntry3,EndGameEntry4 dir=down spacing=0 }
		region { name=BadGuysRegion x=17 y=255 width=656 }
		place { region=BadGuysRegion controls=EndGameEntry5,EndGameEntry6,EndGameEntry7,EndGameEntry8,EndGameEntry9 dir=down spacing=0 }
	}
}

