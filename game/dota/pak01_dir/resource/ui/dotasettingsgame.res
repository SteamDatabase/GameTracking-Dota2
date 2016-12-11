"Resource/UI/DOTASettingsGame.res"
{
	controls
	{
		"DOTASettingsGamePanel"
		{
			"ControlName"			"EditablePanel"
			"fieldName" 			"DOTASettingsGamePanel"
			"visible" 				"1"
			"enabled" 				"1"
			"ypos"					"0"
			"wide"	 				"1024"
			"tall"	 				"671"
			"zpos"					"21"
			"PaintBackground"		"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override"		"58 58 58 255"
		}
		
		"SettingGameBackground"
		{
			"ControlName"			"Panel"
			"fieldName"				"SettingGameBackground"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"0"
			"wide"					"1024"
			"tall"					"671"
			style					"GameBackground"
			MouseInputEnabled		"0"
		}
		
		"ReverseCameraGrip"
		{
			"ControlName"		"CCvarToggleCheckButton"
			"fieldName"			"ReverseCameraGrip"
			"xpos"				"32"
			"ypos"				"32"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"32"
			"minimum-width"		"200"
			"minimum-height"	"32"
			"visible"			"1"
			"enabled"			"1"
			"textAlignment"		"west"
			"style"				"GameSettingsText"
		}		

		"EnableEdgeScrolling"
		{
			"ControlName"		"CCvarToggleCheckButton"
			"fieldName"			"EnableEdgeScrolling"
			"xpos"				"32"
			"ypos"				"72"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"32"
			"minimum-width"		"200"
			"minimum-height"	"32"
			"visible"			"1"
			"enabled"			"1"
			"textAlignment"		"west"
			"style"				"GameSettingsText"
		}		

		"EnableAutoAttack"
		{
			"ControlName"		"CCvarToggleCheckButton"
			"fieldName"			"EnableAutoAttack"
			"xpos"				"32"
			"ypos"				"106"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"32"
			"minimum-width"		"200"
			"minimum-height"	"32"
			"visible"			"1"
			"enabled"			"1"
			"textAlignment"		"west"
			"style"				"GameSettingsText"
		}
				
		"EnableAutoPurchase"
		{
			"ControlName"		"CCvarToggleCheckButton"
			"fieldName"			"EnableAutoPurchase"
			"xpos"				"32"
			"ypos"				"140"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"32"
			"minimum-width"		"200"
			"minimum-height"	"32"
			"visible"			"1"
			"enabled"			"1"
			"textAlignment"		"west"
			"style"				"GameSettingsText"
		}		
		
		"CameraAccelerationTitle"
		{
			"ControlName"		"Label"
			"fieldName"			"CameraAccelerationTitle"
			"xpos"				"512"
			"ypos"				"32"
			"zpos"				"2"
			"wide"				"128"
			"tall"				"32"
			"minimum-width"		"128"
			"minimum-height"	"32"
			"enabled"			"1"
			"visible"			"1"
			"labelText"			"Camera Acceleration"
			"textAlignment"		"east"
			"style"				"GameSettingsText"
		}
		
		"CameraAccelerationSlider"
		{
			"ControlName"		"CCvarSlider"
			"fieldName"			"CameraAccelerationSlider"
			"xpos"				"648"
			"ypos"				"32"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"25"
			"visible"			"1"
			"enabled"			"1"
			"leftText"			"5"
			"rightText"			"50"
			"style"				"GameSettingsText"
		}
		
		"CameraAccelerationLabel"
		{
			"ControlName"		"TextEntry"
			"fieldName"			"CameraAccelerationLabel"
			"xpos"				"850"
			"ypos"				"34"
			"zpos"				"2"
			"wide"				"36"
			"tall"				"28"
			"minimum-width"		"36"
			"minimum-height"	"28"
			"visible"			"1"
			"enabled"			"1"
			"editable"			"1"
			"maxchars"			"-1"
			"NumericInputOnly"	"1"
			"unicode"			"0"
			"style"				"GameSettingsLabel"
		}

		"CameraSpeedTitle"
		{
			"ControlName"		"Label"
			"fieldName"			"CameraSpeedTitle"
			"xpos"				"512"
			"ypos"				"62"
			"zpos"				"2"
			"wide"				"128"
			"tall"				"32"
			"minimum-width"		"128"
			"minimum-height"	"32"
			"enabled"			"1"
			"visible"			"1"
			"labelText"			"Camera Speed"
			"textAlignment"		"east"
			"style"				"GameSettingsText"
		}
		
		"CameraSpeedSlider"
		{
			"ControlName"		"CCvarSlider"
			"fieldName"			"CameraSpeedSlider"
			"xpos"				"648"
			"ypos"				"62"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"30"
			"visible"			"1"
			"enabled"			"1"
			"leftText"			"2000"
			"rightText"			"8000"
			"style"				"GameSettingsText"
		}
		
		"CameraSpeedLabel"
		{
			"ControlName"		"TextEntry"
			"fieldName"			"CameraSpeedLabel"
			"xpos"				"850"
			"ypos"				"64"
			"zpos"				"2"
			"wide"				"36"
			"tall"				"28"
			"minimum-width"		"36"
			"minimum-height"	"28"
			"visible"			"1"
			"enabled"			"1"
			"editable"			"1"
			"maxchars"			"-1"
			"NumericInputOnly"	"1"
			"unicode"			"0"
			"style"				"GameSettingsLabel"
		}
	}
	
	colors
	{
		"GameSettingsTextColor"		"255 255 255 255"
		"GameSettingsBackground"	"43 43 43 255"
	}
	
	
	styles
	{
		"GameBackground"
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_bg_settings.vmat )"
			}
		}
	
		"GameSettingsText"
		{
			textcolor=GameSettingsTextColor
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}

		"GameSettingsLabel"
		{
			textcolor=GameSettingsTextColor
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,GameSettingsBackground)"
			}
		}
	}
			
	include="resource/UI/settings_style.res"		
}