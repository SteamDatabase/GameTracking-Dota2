"Resource/UI/DOTAChatChannelPanel.res"
{
	controls
	{
		"DOTAChatChannelPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAChatChannelPanel"
			"visible" 		"1"
			"enabled" 		"1"
			//"xpos"			"2"
			"ypos"			"22"
			//"wide"	 		"531"
			"tall"	 		"230"
			"bgcolor_override" "0 0 0 0"
			"paintbackgroundenabled" "0"
		}
		
		"Background"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"Background"
			"enabled"			"1"
			"visible"			"0"
			"scaleImage"			"1"
			//"image"				"materials/vgui/hud/ui_items_slot.vmat"
			"fillcolor"			"36 36 36 0"
		}
		
		"DOTAChatHistory"
		{
			"ControlName"			"RichText"
			"fieldName"				"DOTAChatHistory"
			"ypos"					"0"
 			"tall"					"180"
			"wrap"					"1"
			"autoResize"			"1"
			"pinCorner"				"1"
			"visible"				"1"
			"enabled"				"1"
			"labelText"				""
			"textAlignment"			"south-west"
			"font"					"ChatFont"
			"maxchars"				"-1"
			"bgcolor_override"     	"0 0 0 128"
			minimum-height=105
		}

		"DOTAChatInputLine"
		{
			"ControlName"			"EditablePanel"
			"fieldName" 			"DOTAChatInputLine"
			"visible" 				"1"
			"enabled" 				"1"
 			"xpos"		    		"0"
 			"ypos"					"182"
			"zpos"					"2"
 			"tall"	 				"20"
			wide=f0
			tall=f0
			"PaintBackgroundType"	"0"
			"bgcolor_override"     	"0 0 0 0"
		}
	}
	include="resource/UI/dashboard_style.res"
	
	layout
	{
	}
}
