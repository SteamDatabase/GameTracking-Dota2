"Resource/UI/HUD_CombatLog.res"
{
	"DOTACombatLogPanel"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"DOTACombatLogPanel"
		"xpos"					"%0.0"
		"ypos"					"%5.0"
		"zpos"					"0"
		"wide"					"%50.0"
		"tall"					"%56.0"
		"visible"				"0"
		"enabled"				"1"
		"bgcolor_override"		"0 0 0 255"
		"fgcolor_override"		"0 0 0 255"
	}

	"DOTACombatLogPanelBackground"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"DOTACombatLogPanelBackground"
		"xpos"					"%0.0"
		"ypos"					"%0.0"
		"zpos"					"0"
		"wide"					"%50.0"
		"tall"					"%56.0"
		"visible"				"1"
		"enabled"				"1"
		"bgcolor_override"		"0 0 0 255"
		"fgcolor_override"		"0 0 0 255"
	}
	
	"HeadingLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"HeadingLabel"
		"xpos"				"%12.0"
		"ypos"				"%0.5"
		"zpos"				"3"
		"wide"				"%26.0"
		"tall"				"%2.0"
		"enabled"			"1"
		"textAlignment"		"center"
		"labelText"			"#DOTA_CombatLogHeading"
		"font" 				"CombatLogFont"
		"fgColor_override" 	"255 255 255 255"
		"bgcolor_override"	"0 0 0 255"
	}

	"LogText"
	{
		"ControlName"		"RichText"
		"fieldName"			"LogText"
		"xpos"				"%1.0"
		"ypos"				"%3.0"
		"zpos"				"3"
		"wide"				"%48.0"
		"tall"				"%45.0"
		"wrap"			"1"
		"autoResize"		"1"
		"pinCorner"		"1"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		""
		"textAlignment"		"north-west"
		"maxchars"		"-1"
		"font"				"DIN10Fine"
		"fgColor_override" 	"40 240 40 255"
		"bgcolor_override"	"40 40 40 255"
	}
	
	"CloseButton"
	{
		"ControlName"			"CDOTAButton"
		"fieldName"				"CloseButton"
		"xpos"					"%42.5"
		"ypos"					"%52.0"
		"zpos"					"3"
		"wide"					"%6.5"
		"tall"					"%2.5"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"center"
		"command"				"closecombatlog"
		"labelText"				"Close"
		"defaultBgColor_override"		"40 40 40 255"
		"defaultFgColor_override"		"200 200 200 255"
		"armedBgColor_override"		"40 40 40 255"
		"armedFgColor_override"		"200 200 200 255"
	}

	"RefreshButton"
	{
		"ControlName"			"CDOTAButton"
		"fieldName"				"RefreshButton"
		"xpos"					"%42.5"
		"ypos"					"%48.8"
		"zpos"					"3"
		"wide"					"%6.5"
		"tall"					"%2.5"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"center"
		"command"				"refreshcombatlog"
		"labelText"				"Refresh"
		"defaultBgColor_override"		"40 40 40 255"
		"defaultFgColor_override"		"200 200 200 255"
		"armedBgColor_override"		"40 40 40 255"
		"armedFgColor_override"		"200 200 200 255"
	}
	
	"AttackerFilterLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"AttackerFilterLabel"
		"xpos"				"%1.0"
		"ypos"				"%49.5"
		"zpos"				"3"
		"wide"				"%4.0"
		"tall"				"%2.0"
		"enabled"			"1"
		"textAlignment"		"left"
		"labelText"			"Attacker"
		"font"				"DefaultTiny"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"0 0 0 255"
	}
	
	"AttackerFilter" 
	{
		"ControlName"		"ComboBox"
		"fieldName"		"AttackerFilter"
		"xpos"		"%5.5"
		"ypos"		"%49.0"
		"zpos"		"3"
		"wide"		"%10"
		"tall"		"%2.5"
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
	
	"TargetFilterLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"TargetFilterLabel"
		"xpos"				"%1.0"
		"ypos"				"%52.0"
		"zpos"				"3"
		"wide"				"%4.5"
		"tall"				"%2.0"
		"enabled"			"1"
		"textAlignment"		"left"
		"labelText"			"Target"
		"font"				"DefaultTiny"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"0 0 0 255"
	}
	
	"TargetFilter" //drop down challenge box
	{
		"ControlName"		"ComboBox"
		"fieldName"		"TargetFilter"
		"xpos"		"%5.5"
		"ypos"		"%52.0"
		"zpos"		"3"
		"wide"		"%10"
		"tall"		"%2.5"
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

	"DamageCheck"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"DamageCheck"
		"xpos"		"%16.5"
		"ypos"		"%48.8"
		"zpos"		"3"
		"wide"		"%10"
		"tall"		"%2.5"
		"autoResize"		"1"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"Damage"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Default"		"0"
	}
	
	"HealCheck"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"HealCheck"
		"xpos"		"%16.5"
		"ypos"		"%51.0"
		"zpos"		"3"
		"wide"		"%10"
		"tall"		"%2.5"
		"autoResize"		"1"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"Healing"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Default"		"0"
	}

	"ModifierCheck"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"ModifierCheck"
		"xpos"		"%24.0"
		"ypos"		"%49.0"
		"zpos"		"4"
		"wide"		"%10"
		"tall"		"%2.5"
		"autoResize"		"1"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"Modifiers"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Default"		"0"
	}

	"DeathCheck"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"DeathCheck"
		"xpos"		"%24.0"
		"ypos"		"%51.0"
		"zpos"		"4"
		"wide"		"%10"
		"tall"		"%2.5"
		"autoResize"		"1"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"Deaths"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Default"		"0"
	}

	"IntervalLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"IntervalLabel"
		"xpos"				"%33.0"
		"ypos"				"%49.0"
		"zpos"				"3"
		"wide"				"%9.0"
		"tall"				"%2.0"
		"enabled"			"1"
		"textAlignment"		"left"
		"labelText"			"Interval_"
		"font"				"DefaultTiny"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"0 0 0 255"
	}

	"IntervalSlider"
	{
		"ControlName"		"Slider"
		"fieldName"			"IntervalSlider"
		"xpos"				"%33.0"
		"ypos"				"%51.0"
		"zpos"				"3"
		"wide"				"%9.0"
		"tall"				"%2.0"
		"enabled"			"1"
		"textAlignment"		"left"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"0 0 0 255"
	}
	
	"Styles"
	{
		CheckButton
		{
			font=DefaultTiny
		}
		
		ComboBox
		{
			font=DefaultTiny
		}
		
		MenuItem
		{
			font=DefaultTiny
		}
	}		

}

