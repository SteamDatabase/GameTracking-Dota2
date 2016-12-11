"Resource/UI/DOTAPlayPanel.res"
{
	controls
	{
		"DOTAPlayPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAPlayPanel"

			"ypos"			"0"
			"wide"	 		"512"
			"tall"	 		"416"
			"zpos"			"5"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
		
		"Background" { ControlName=ImagePanel fieldName=Background xpos=0 ypos=0 zpos=-2 wide=512 tall=416 mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_panel_center }
		
		"BackgroundInnerTop" { Controlname=Panel fieldName=BackgroundInnerTop xpos=9 ypos=7 zpos=-1 wide=494 tall=157 style=DashboardPlayInnerBackground mouseInputEnabled=0 }
		"BackgroundInnerOptions" { Controlname=Panel fieldName=BackgroundInnerOptions xpos=9 ypos=172 zpos=-1 wide=494 tall=65 style=DashboardPlayInnerBackground mouseInputEnabled=0 }
		"BackgroundInnerParty" { Controlname=Panel fieldName=BackgroundInnerParty xpos=9 ypos=243 zpos=-1 wide=494 tall=81 style=DashboardPlayInnerBackground mouseInputEnabled=0 }
		"BackgroundInnerLaunch" { Controlname=Panel fieldName=BackgroundInnerLaunch xpos=9 ypos=332 zpos=-1 wide=494 tall=65 style=DashboardPlayInnerBackground mouseInputEnabled=0 }
		
		"MatchButtonBG" { ControlName=ImagePanel fieldName=MatchButtonBG wide=112 tall=112 scaleImage=1 image=dashboard/dash_panel_well minimum-width=112 minimum-height=112 }
		"TournamentButtonBG" { ControlName=ImagePanel fieldName=TournamentButtonBG wide=112 tall=112 scaleImage=1 image=dashboard/dash_panel_well minimum-width=112 minimum-height=112 }
		"PracticeButtonBG" { ControlName=ImagePanel fieldName=PracticeButtonBG wide=112 tall=112 scaleImage=1 image=dashboard/dash_panel_well minimum-width=112 minimum-height=112 }
		"TutorialButtonBG" { ControlName=ImagePanel fieldName=TutorialButtonBG wide=112 tall=112 scaleImage=1 image=dashboard/dash_panel_well minimum-width=112 minimum-height=112 }
		
		"MatchButton" { ControlName=Button fieldName=MatchButton command=PlayType_0 xpos=20 ypos=26 wide=106 tall=106 zpos=1 style=MatchButtonStyle labelText="" minimum-width=106 minimum-height=106 }
		"TournamentButton" { ControlName=Button fieldName=TournamentButton command=PlayType_1 xpos=140 ypos=26 wide=106 tall=106 zpos=1 style=TournamentButtonStyle labelText="" minimum-width=106 minimum-height=106 }
		"PracticeButton" { ControlName=Button fieldName=PracticeButton command=PlayType_2 xpos=260 ypos=26 wide=106 tall=106 zpos=1 style=PracticeButtonStyle labelText="" minimum-width=106 minimum-height=106 }
		"TutorialButton" { ControlName=Button fieldName=TutorialButton command=PlayType_3 xpos=380 ypos=26 wide=106 tall=106 zpos=1 style=TutorialButtonStyle labelText="" minimum-width=106 minimum-height=106 }
		
		"MatchLabel" { ControlName=Label fieldName=MatchLabel xpos=12 ypos=138 wide=112 tall=16 style=PlayButtonLabel labelText="MATCH" textAlignment=center minimum-width=112 }	// TODO:Localize
		"TournamentLabel" { ControlName=Label fieldName=TournamentLabel xpos=132 ypos=138 wide=112 tall=16 style=PlayButtonLabel labelText="TOURNAMENT" textAlignment=center minimum-width=112 }	// TODO:Localize
		"PracticeLabel" { ControlName=Label fieldName=PracticeLabel xpos=252 ypos=138 wide=112 tall=16 style=PlayButtonLabel labelText="PRACTICE" textAlignment=center minimum-width=112 }	// TODO:Localize
		"TutorialLabel" { ControlName=Label fieldName=TutorialLabel xpos=372 ypos=138 wide=112 tall=16 style=PlayButtonLabel labelText="TUTORIAL" textAlignment=center minimum-width=112 }	// TODO:Localize
		
		"GameModeComboBG" { ControlName=ImagePanel fieldName=GameModeComboBG xpos=15 ypos=184 wide=243 tall=40 mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_button_drop_shadow.vmt }
		"GameModeCombo" { ControlName=ComboBox fieldName=GameModeCombo xpos=19 ypos=188 wide=235 tall=32 style=ComboBox editable=0 zpos=1 }
		"GameModeLabel" { ControlName=Label fieldName=GameModeLabel xpos=272 ypos=189 wide=235 tall=48 textAlignment=north-west wrap=1 zpos=2 style=GameModeLabelStyle allcaps=1 }
		
		"PingPartyButton" { ControlName=Button fieldName=PingPartyButton command=PingPartyButton xpos=18 ypos=340 wide=235 zpos=1 tall=48 textAlignment=center labelText="PING PARTY" style=PingPartyButtonStyle }	// TODO:Localize
		"FindMatchButton" { ControlName=Button fieldName=FindMatchButton command=FindMatchButton xpos=259 ypos=340 wide=235 zpos=1 tall=48 textAlignment=center labelText="FIND MATCH" style=FindMatchButtonStyle }	// TODO:Localize
		
		"StartAIGameButton" { ControlName=Button fieldName=StartAIGameButton command=PlayAIButton xpos=18 ypos=340 wide=235 zpos=2 tall=48 textAlignment=center labelText="PLAY AGAINST AI" style=PingPartyButtonStyle }	// TODO:Localize
		"CreateLobbyButton" { ControlName=Button fieldName=CreateLobbyButton command=CreateLobby xpos=259 ypos=340 wide=235 zpos=2 tall=48 textAlignment=center labelText="CREATE LOBBY" style=FindMatchButtonStyle }	// TODO:Localize

		"StartTutorialButton" { ControlName=Button fieldName=StartTutorialButton command=StartTutorialLesson xpos=18 ypos=340 wide=235 zpos=2 tall=48 textAlignment=center labelText="START LESSON" style=PingPartyButtonStyle }	// TODO:Localize		
	}
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		dullwhite="205 205 205 255"
		white="255 255 255 255"
	}
	
	styles
	{
		include="resource/UI/dashboard_style.res"
		
		MatchButtonStyle			{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_match.vmat)" }	}
		MatchButtonStyle:hover		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_match.vmat)" }	}
		MatchButtonStyle:active		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_match.vmat)" }	}
		MatchButtonStyle:selected	{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_selected)" 1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_match.vmat)" }	}

		TournamentButtonStyle			{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tournament.vmat)" }	}
		TournamentButtonStyle:hover		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tournament.vmat)" }	}
		TournamentButtonStyle:active	{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tournament.vmat)" }	}
		TournamentButtonStyle:selected	{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_selected)" 1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tournament.vmat)" }	}

		PracticeButtonStyle				{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_practice.vmat)" }	}
		PracticeButtonStyle:hover		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_practice.vmat)" }	}
		PracticeButtonStyle:active		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_practice.vmat)" }	}
		PracticeButtonStyle:selected	{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_selected)" 1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_practice.vmat)" }	}

		TutorialButtonStyle				{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tutorial.vmat)" }	}
		TutorialButtonStyle:hover		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tutorial.vmat)" }	}
		TutorialButtonStyle:active		{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_bg)"		1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tutorial.vmat)" }	}
		TutorialButtonStyle:selected	{ bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,dashboard/dash_button_large_selected)" 1="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_large_glyph_tutorial.vmat)" }	}
		
		PlayButtonLabel		{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg { 0="fill(x0,y0,x1,y1,none)" } }
		GameModeLabelStyle	{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg { 0="fill(x0,y0,x1,y1,none)" } }
		
		FindMatchButtonStyle			{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_positive_bg.vmat)"	}	}
		FindMatchButtonStyle:hover		{ font=Arial18Thick textcolor=white bgcolor=none render_bg		{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_positive_bg.vmat)"	}	}
		FindMatchButtonStyle:active		{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_positive_bg.vmat)"	}	}
		
		PingPartyButtonStyle			{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		PingPartyButtonStyle:hover		{ font=Arial18Thick textcolor=white bgcolor=none render_bg		{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		PingPartyButtonStyle:active		{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}		
	}	
	
	layout
	{
		region { name=ButtonBGRegion x=18 y=16 width=488 }
		place { region=ButtonBGRegion controls=MatchButtonBG,TournamentButtonBG,PracticeButtonBG,TutorialButtonBG dir=right spacing=8 }
		
		region { name=ButtonRegion x=21 y=19 width=488 }
		place { region=ButtonRegion controls=MatchButton,TournamentButton,PracticeButton,TutorialButton dir=right spacing=14 }
		
		region { name=ButtonLabelRegion x=18 y=137 width=488 }
		place { region=ButtonLabelRegion controls=MatchLabel,TournamentLabel,PracticeLabel,TutorialLabel dir=right spacing=8 }
		
		region { name=PartySlotRegion x=80 y=251 width=400 }
		place { region=PartySlotRegion controls=PartySlot0,PartySlot1,PartySlot2,PartySlot3,PartySlot4 dir=right spacing=8 }
	}
}
