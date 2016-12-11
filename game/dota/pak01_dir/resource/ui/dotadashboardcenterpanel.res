"Resource/UI/DOTADashboardCenterPanel.res"
{
	controls
	{
		"DOTADashboardCenterPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTADashboardCenterPanel"
			"visible" 		"0"
			"enabled" 		"1"
			"xpos"			"c-288"
			//"ypos"			"8"
			"wide"	 		"576"
			"tall"	 		"425"
			"zpos"			"20"
			"PaintBackground"	"0"
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
			"tall"				"442"
			"bgcolor_override"	"19 19 19 255"
		}
		
		"FakeTabBackground"
		{
			"ControlName"			"Panel"
			"fieldName"			"FakeTabBackground"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"200"
			"tall"				"36"
			"bgcolor_override"	"19 19 19 255"
			"paintbackgroundtype"	"2"
			"visible" 		"0"
		}
		
	// 	"TitleBar"
	// 	{
	// 		"ControlName"			"ImagePanel"
	// 		"fieldName"			"TitleBar"
	// 		"xpos"				"0"
	// 		"ypos"				"0"
	// 		"zpos"				"2"
	// 		"wide"				"576"
	// 		"tall"				"24"
	// 		"enabled"			"1"
	// 		"visible"			"1"
	// 		"scaleImage"			"1"
	// 		//"image"			
	// 		"fillcolor"			"21 21 21 255"
	// 	}
		
		"Title"
		{
 			"ControlName"			"Label"
 			"fieldName"			"Title"
 			"xpos"				"12"
 			"ypos"				"5"
 			"zpos"				"3"
 			"wide"				"576"
 			"tall"				"20"
 			"enabled"			"1"
 			"visible"			"0"
 			"textAlignment"		"west"
 			"labelText"			"DOTA TODAY"
 			"Style"				"DashboardTitle"
 			"visible" 		"0"
 		}
		
		"NumPlayersLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"NumPlayersLabel"
			"xpos"				"12"
			"ypos"				"22"
			"zpos"				"3"
			"wide"				"300"
			"tall"				"15"
			"enabled"			"1"
			"visible"			"0"
			"textAlignment"		"north-west"
			"Style"				"PlayersOnlineStyle"
			"visible" 		"0"
		}
		
		
		"ProfileLastPlayedModel"
		{
			"ControlName"			"CDOTA_Model_Panel"
			"fieldName"			"ProfileLastPlayedModel"
			"xpos"				"93"
			"ypos"				"72"
			"wide"				"406"
			"tall"				"271"
			"zpos"				"3"
			"autoResize"			"0"
			"pinCorner"			"0"
			"visible"			"0"
			"enabled"			"1"
			"fov"				"30"
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
		
		"Illustration"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"Illustration"
			"xpos"				"12"
			"ypos"				"12"
			"wide"				"546"
			"tall"				"345"
			"zpos"				"5"
			"scaleImage"		"1"
			"image"				"materials/vgui/dashboard/illustration.vmat"
			"visible"			"1"
		}
		
// 		"VideoPanel"
// 		{
// 			"ControlName"		"Panel"
// 			"fieldName"			"VideoPanel"
// 			"xpos"				"12"
// 			"ypos"				"6"
// 			"wide"				"546"
// 			"tall"				"351"
// 			"zpos"				"5"
// 			"videofile"			"media/intro.bik"
// 			"loop"				"0"
// 		}
		
		"ContentButton0" { ControlName="Panel" fieldName="ContentButton0" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
		"ContentButton1" { ControlName="Panel" fieldName="ContentButton1" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
		"ContentButton2" { ControlName="Panel" fieldName="ContentButton2" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
		"ContentButton3" { ControlName="Panel" fieldName="ContentButton3" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
		"ContentButton4" { ControlName="Panel" fieldName="ContentButton4" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
		"ContentButton5" { ControlName="Panel" fieldName="ContentButton5" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
		"ContentButton6" { ControlName="Panel" fieldName="ContentButton6" wide=50 tall=50 style=ContentButtonStyle visible=1 enabled=1 zpos=100 }
	}
		
	include="resource/UI/dashboard_style.res"	
	
	layout
	{
		region { name=ContentButtonRegion x=12 y=363 width=546 }
		place { region=ContentButtonRegion controls=ContentButton0,ContentButton1,ContentButton2,ContentButton3,ContentButton4,ContentButton5,ContentButton6 dir=right spacing=6 }
	}
	
	colors
	{
		"ContentButtonGradientTop"		"145 145 145 255"
		"ContentButtonGradientBottom"		"86 86 86 255"
	}
	
	styles
	{
		ContentButtonStyle
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, ContentButtonGradientTop, ContentButtonGradientBottom )"
				1="fill(x0,y0,x1,y1,red)"
			}
		}
		PlayersOnlineStyle
		{
			textcolor=TabButtonText
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
