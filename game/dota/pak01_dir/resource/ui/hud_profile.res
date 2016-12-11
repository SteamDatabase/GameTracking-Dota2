"Resource/UI/HUD_UnitStatus.res"
{
	"DOTAProfilePanel"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"DOTAProfilePanel"
		"xpos"				"%55"
		"ypos"				"%5"
		"zpos"				"20"
		"wide"				"%40"
		"tall"				"%75"
		"visible"			"1"
		"enabled"			"1"
		"fgcolor_override"		"51 51 51 255"
		"bgcolor_override"		"51 51 51 255"
	}

	"ProfilePanelBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"			"ProfilePanelBackground"
		"xpos"				"%0"
		"ypos"				"%0"
		"zpos"				"0"
		"wide"				"%40"
		"tall"				"%75"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		//"image"			
		"fillcolor"			"51 51 51 255"
	}

	"HeaderImageBackground"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"HeaderImageBackground"
		"xpos"				"%0.70"
		"ypos"				"%1"
		"zpos"				"1"
		"wide"				"%38.70"
		"tall"				"%15"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		//"image"				"materials/vgui/hud/ui_items_slot.vmat"
		"fillcolor"			"36 36 36 255"
	}

	"BottomImageBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"			"BottomImageBackground"
		"xpos"				"%0.70"
		"ypos"				"%17"
		"zpos"				"1"
		"wide"				"%38.70"
		"tall"				"%57"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		//"image"				"materials/vgui/hud/ui_items_slot.vmat"
		"fillcolor"			"36 36 36 255"
	}

//=====================================================================================================================
//
// HEADER
//
	"PlayerNameBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"			"PlayerNameBackground"
		"xpos"				"%1"
		"ypos"				"%1.75"
		"zpos"				"2"
		"wide"				"%20"
		"tall"				"%5.50"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		//"image"			"materials/vgui/hud/ui_items_slot.vmat"
		"fillcolor"			"0 0 0 255"
	}

	"Avatar"
	{
		"ControlName"		"CAvatarImagePanel"
		"fieldName"		"Avatar"
		"xpos"			"%17.8"
		"ypos"			"%2.25"
		"wide"			"%3"
		"tall"			"%4.5"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"		"1"
		"autoResize"		"0"
		"pinCorner"		"0"
		"fgcolor_override" 	"255 255 255 255"
		"drawcolor_override" 	"255 255 255 255"
		"alpha"			"255"
		"zpos"			"3"
	}

	"PlayerName"
	{
		"ControlName"			"Label"
		"fieldName"			"PlayerName"
		"xpos"				"%0.5"
		"ypos"				"%0"
		"zpos"				"3"
		"wide"				"%3"
		"tall"				"%4.5"
		"enabled"			"1"
		"textAlignment"			"south-east"
		"labelText"			"%playername%"
		"font" 				"PlayerProfileBig"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"

		"pin_to_sibling"		"Avatar"
		"pin_corner_to_sibling" 	"3"
		"pin_to_sibling_corner"		"2"
	}


//=====================================================================================================================
//
// STATS
//
	"StatsBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"			"StatsBackground"
		"xpos"				"%21.5"
		"ypos"				"%1.75"
		"zpos"				"2"
		"wide"				"%17.60"
		"tall"				"%13.5"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		//"image"			"materials/vgui/hud/ui_items_slot.vmat"
		"fillcolor"			"0 0 0 255"
	}

	"GamesWon"
	{
		"ControlName"			"Label"
		"fieldName"			"GamesWon"
		"xpos"				"%22"
		"ypos"				"%2"
		"zpos"				"3"
		"wide"				"%3"
		"tall"				"%4.5"
		"enabled"			"1"
		"textAlignment"			"west"
		"labelText"			"Games Won: 420 (50% of total)"
		"font" 				"PlayerProfileMedium"
		"fgColor_override" 		"75 255 75 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"
	}

	"GamesLost"
	{
		"ControlName"			"Label"
		"fieldName"			"GamesWon"
		"xpos"				"%22"
		"ypos"				"%4"
		"zpos"				"3"
		"wide"				"%3"
		"tall"				"%4.5"
		"enabled"			"1"
		"textAlignment"			"west"
		"labelText"			"Games Lost: 420 (50% of total)"
		"font" 				"PlayerProfileMedium"
		"fgColor_override" 		"75 255 75 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"
	}

	"GamesPlayed"
	{
		"ControlName"			"Label"
		"fieldName"			"GamesPlayed"
		"xpos"				"%22"
		"ypos"				"%6"
		"zpos"				"3"
		"wide"				"%3"
		"tall"				"%4.5"
		"enabled"			"1"
		"textAlignment"			"west"
		"labelText"			"Games Played: 840"
		"font" 				"PlayerProfileMedium"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"
	}

	"WinStreak"
	{
		"ControlName"			"Label"
		"fieldName"			"WinStreak"
		"xpos"				"%22"
		"ypos"				"%8"
		"zpos"				"3"
		"wide"				"%3"
		"tall"				"%4.5"
		"enabled"			"1"
		"textAlignment"			"west"
		"labelText"			"Win Streak: 12 games"
		"font" 				"PlayerProfileMedium"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"
	}


	"RankBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"			"RankBackground"
		"xpos"				"%1"
		"ypos"				"%8"
		"zpos"				"2"
		"wide"				"%20"
		"tall"				"%7.20"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		//"image"			"materials/vgui/hud/ui_items_slot.vmat"
		"fillcolor"			"0 0 0 255"
	}

	"Rank"
	{
		"ControlName"			"Label"
		"fieldName"			"WinStreak"
		"xpos"				"%2"
		"ypos"				"%9"
		"zpos"				"3"
		"wide"				"%3"
		"tall"				"%2"
		"enabled"			"1"
		"textAlignment"			"west"
		"labelText"			"World Rank: 420th"
		"font" 				"PlayerProfileMedium"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"
	}



	"ProfileLastPlayedModel"
	{
		"ControlName"			"CDOTA_Model_Panel"
		"fieldName"			"ProfileLastPlayedModel"
		"xpos"				"%6"
		"ypos"				"%18"
		"wide"				"%25"
		"tall"				"%40"
		"zpos"				"2"
		"autoResize"			"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"fov"				"20"
		"start_framed"			"0"
		
		"model"
		{
			"modelname"			"models/heroes/juggernaut.mdl"
			"skin"				"0"
			"angles_y"			"60"
			"origin_x"			"0"
			"origin_x_lodef"	"0"
			"origin_x_hidef"	"0"
			"origin_y"			"0"
			"origin_z"			"0"
		}
	}	

	
}
