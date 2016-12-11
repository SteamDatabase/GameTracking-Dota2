"Resource/UI/HUD_SpectatorAll.res"
{
	// Base.
	"HudDOTASpectatorAll"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudDOTASpectatorAll"
		"xpos"				"5"
		"ypos"				"425"
		"zpos"				"0"
		"wide"				"300"
		"tall"				"150"
		"visible"			"1"
		"enabled"			"1"
		"bgcolor_override"	"0 0 0 0"
		"fgcolor_override"	"0 0 0 0"	
	}	
	
	"BackgroundSpectator"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"BackgroundSpectator"
		"fillcolor"			"36 36 36 255"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"1"
		"wide"				"300"
		"tall"				"205"
		"enabled"			"0"
		"visible"			"1"
	}

	"BackgroundSpectator2"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"BackgroundSpectator2"
		"fillcolor"			"0 0 0 255"
		"xpos"				"5"
		"ypos"				"5"
		"zpos"				"2"
		"wide"				"291"
		"tall"				"142"		
		"enabled"			"0"
		"visible"			"1"
	}
	
	"SpectatorModeLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"SpecPlayerName"
		"xpos"					"15"
		"ypos"					"13"
		"zpos"					"4"
		"wide"					"150"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				"#DOTA_Spectator_SpectatorMode"
		"textAlignment"			"west"
		"font"					"Arial12Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"
	}
	
	"SpectatorModes" 
	{
		"ControlName"		"ComboBox"
		"fieldName"			"SpectatorModes"
		"xpos"		"15"
		"ypos"		"25"
		"zpos"		"3"
		"wide"		"200"
		"tall"		"23"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"4"
		"textHidden"	"0"
		"editable"		"0"
		"maxchars"		"-1"
		"NumericInputOnly"		"0"
		"unicode"		"0"
	}
	
	"HeroListLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"HeroListLabel"
		"xpos"					"15"
		"ypos"					"59"
		"zpos"					"4"
		"wide"					"150"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				"#DOTA_Spectator_HeroList"
		"textAlignment"			"west"
		"font"					"Arial12Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"
	}
	"PlayerList" 
	{
		"ControlName"		"ComboBox"
		"fieldName"			"PlayerList"
		"xpos"		"15"
		"ypos"		"70"
		"zpos"		"3"
		"wide"		"200"
		"tall"		"23"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"4"
		"textHidden"	"0"
		"editable"		"0"
		"maxchars"		"-1"
		"NumericInputOnly"		"0"
		"unicode"		"0"
	}
	
	"FogOFWarLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"FogOFWarLabel"
		"xpos"					"15"
		"ypos"					"103"
		"zpos"					"4"
		"wide"					"150"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				"#DOTA_Spectator_FOWLabel"
		"textAlignment"			"west"
		"font"					"Arial12Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"
	}
	
	"FOWType" 
	{
		"ControlName"		"ComboBox"
		"fieldName"			"FOWType"
		"xpos"		"15"
		"ypos"		"115"
		"zpos"		"3"
		"wide"		"200"
		"tall"		"23"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"4"
		"textHidden"	"0"
		"editable"		"0"
		"maxchars"		"-1"
		"NumericInputOnly"		"0"
		"unicode"		"0"
	}
	
	Colors
	{
		"dullwhite"		"125 125 125 255"
	}
	
	Styles
	{
		gamedatastyle	
		{ 
			textcolor=dullwhite 
		}
		
		clock	
		{ 
			textcolor=dullwhite 
			font=Arial10Thick 
			render_bg 
			{ 
				0="roundedfill(x0,y0,x1,y1,7,Black)" 
			}
		}
	}
}