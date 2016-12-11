"Resource/UI/HUD_Base.res"
{
	"HudMiniKillCam"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudMiniKillCam"
		"xpos"				"c-130"
		"ypos"				"r300"
		"wide"				"400"
		"tall"				"120"
		"zpos"				"500"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"1"
		"bgcolor_override"	"50 50 50 125"
		"fgcolor_override"	"0 0 0 255"
	}

	"Back" //back button
	{
		"ControlName"		"Button"
		"fieldName"		"Back"
		"xpos"		"205"
		"ypos"		"97"
		"wide"		"80"
		"tall"		"15"
		"zpos"		"10"
		"autoResize"		"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"4"
		"labelText"		"Tell Me More!"
		"textAlignment"		"center"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Command"		"expand"
		"defaultFgColor_override"		"75 9 7 255"
		"bgcolor_override"		"75 9 7 255"
		
		"style" "buttonstyle"
	}
	
	"KillerPortraitModel"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"KillerPortraitModel"
		"xpos"				"4"
		"ypos"				"4"
		"zpos"				"4"
		"wide"				"98"
		"tall"				"109"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"fov"				"20"
		"start_framed"		"0"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/portrait_killcam.vmat"
	}	
		
	"HudMiniKillCamBackgroundKiller"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudMiniKillCamBackgroundKiller"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"106"
		"tall"					"112"
		"zpos"					"1"
		"autoResize"			"0"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"west"
		"dulltext"				"0"
		"brighttext"			"1"
		//"bgcolor_override"		"29 29 29 255"
		//"fgcolor_override"		"0 0 0 0"
		"bgcolor_override"		"75 9 7 255"
		"fgcolor_override"		"0 0 0 0"
		"PaintBackgroundType"	"2"
	}
	
	"HudMiniKillCamBackgroundKillerBLACK"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudMiniKillCamBackgroundKillerBLACK"
		"xpos"					"2"
		"ypos"					"2"
		"wide"					"103"
		"tall"					"112"
		"zpos"					"2"
		"autoResize"			"0"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"west"
		"dulltext"				"0"
		"brighttext"			"1"
		"bgcolor_override"		"29 29 29 255"
		"fgcolor_override"		"0 0 0 0"
		"PaintBackgroundType"	"2"
	}
		
	"HudMiniKillCamBackgroundKillerInformation"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudMiniKillCamBackgroundKillerInformation"
		"xpos"					"0"
		"ypos"					"72"
		"wide"					"400"
		"tall"					"45"
		"zpos"					"0"
		"autoResize"				"0"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"				"west"
		"dulltext"				"0"
		"brighttext"				"1"
	//	"bgcolor_override"			"29 29 29 255"
	//	"fgcolor_override"			"0 0 0 0"
		"bgcolor_override"		"75 9 7 255"
		"fgcolor_override"		"0 0 0 0"
		"PaintBackgroundType"			"2"
	}
	
	"HudMiniKillCamBackgroundKillerInformationBLACK"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudMiniKillCamBackgroundKillerInformationBLACK"
		"xpos"					"2"
		"ypos"					"74"
		"wide"					"396"
		"tall"					"41"
		"zpos"					"2"
		"autoResize"				"0"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"				"west"
		"dulltext"				"0"
		"brighttext"				"1"
		"bgcolor_override"			"29 29 29 255"
		"fgcolor_override"			"0 0 0 0"
		"PaintBackgroundType"			"2"
	}

	"KillerInfo"
	{
		"ControlName"		"Label"
		"fieldName"			"KillerInfo"
		"xpos"				"144"
		"ypos"				"75"
		"zpos"				"8"
		"wide"				"640"
		"tall"				"20"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"center"
		"wrap"				"0"
		"scrollbar"			"false"
		"labeltext"			"%killerinfo%"
		"font" 				"Arial18Thick"
		"fgColor_override" 		"200 200 200 255"
		"bgcolor_override"		"0 0 0 0"
		"auto_wide_tocontents"		"1"
		"auto_tall_tocontents"		"1"
	}
	
	styles
	{
		buttonstyle 
		{ 
			font=Times14Fine
			textcolor=White
			
			render_bg
			{
				0="fill( x0, y0, x1, y1, killcamgrey)"
				1="fill( x0+1, y0+1, x1-1, y1-1, black)"
			}
		}
		buttonstyle:hover
		{ 
			font=Times14Fine
			textcolor=killcamgrey
		}
	}
	
	colors
	{
		killcamred="75 9 7 255"
		killcamgrey="125 125 125 255"
	}
}
