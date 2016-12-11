"Resource/UI/DOTASettingsKeyboard.res"
{
	controls
	{
		"DOTASettingsKeyboardPanel"
		{
			"ControlName"			"EditablePanel"
			"fieldName" 			"DOTASettingsKeyboardPanel"
			"visible" 				"1"
			"enabled" 				"1"
			"xpos"					"0"
			"ypos"					"0"
			"wide"	 				"1024"
			"tall"	 				"800"
			"zpos"					"21"
			"PaintBackground"		"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override"		"58 58 58 255"
		}
		
		"SettingKeyboardBackground"
		{
			"ControlName"			"Panel"
			"fieldName"				"SettingKeyboardBackground"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"0"
			"wide"					"1024"
			"tall"					"800"
			style					"KeyboardBackground"
			MouseInputEnabled		"0"
		}		

	//=========================================================================
	//
	// Base Binding
	//

		"BaseBindingSettingsBackground"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"BaseBindingSettingsBackground"
			"fillcolor"				"43 43 43 255"
			"zpos"					"3"
			"wide"					"144"
			"tall"					"32"
			"minimum-width"			"144"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
		}

		"KeyboardSettingsResetButton"
		{
			"ControlName"			"Button"
			"fieldName"				"KeyboardSettingsResetButton"
			"zpos"					"7"
			"wide"					"40"
			"tall"					"30"
			"minimum-width"			"40"
			"minimum-height"		"30"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"RESET"
			"style"					"ResetButtonStyle"
			"command"				"resetkeys"
		}

		"HeroSelectionSettingsBackground"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"HeroSelectionSettingsBackground"
			"fillcolor"				"43 43 43 255"
			"zpos"					"3"
			"wide"					"856"
			"tall"					"32"
			"minimum-width"			"856"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
		}

		"HeroOverridesLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"HeroOverridesLabel"
			"zpos"				"5"
			"wide"				"160"
			"tall"				"32"
			"minimum-width"		"160"
			"minimum-height"	"32"
			"enabled"			"1"	
			"visible"			"1"
			"textAlignment"		"west"
			"labelText"			"HERO OVERRIDES"
			"style"				"KeyboardSettingsTitle"
		}	

		"HeroOverridesLabelTemp"
		{
			"ControlName"		"Label"
			"fieldName"			"HeroOverridesLabelTemp"
			"zpos"				"5"
			"wide"				"864"
			"tall"				"32"
			"minimum-width"		"864"
			"minimum-height"	"32"
			"enabled"			"1"	
			"visible"			"1"
			"textAlignment"		"center"
			"labelText"			"{Coming Soon!}"
			"style"				"KeyboardSettingsTitle"
		}	
			
	//=========================================================================
	//
	// Camera
	//

		"CameraSettingsBackground"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"CameraSettingsBackground"
			"fillcolor"				"43 43 43 255"
			"zpos"					"4"
			"wide"					"336"
			"tall"					"248"
			"minimum-width"			"336"
			"minimum-height"		"248"
			"enabled"				"1"
			"visible"				"1"
		}

		"CameraHomeButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"CameraHomeButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"CameraHomeButtonStyle"
		}

		"CameraHomeLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraHomeLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"CameraHomeName"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraHomeName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PAN HOME"
			"style"					"KeyboardSettingsTitle"
		}

		"CameraUpButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"CameraUpButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"CameraUpButtonStyle"
		}
		
		"CameraUpLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraUpLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"CameraUpName"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraUpName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PAN UP"
			"style"					"KeyboardSettingsTitle"
		}

		"CameraGripButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"CameraGripButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"CameraGripButtonStyle"
		}
		
		"CameraGripLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraGripLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"CameraGripName"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraGripName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PAN GRIP"
			"style"					"KeyboardSettingsTitle"
		}

		"CameraLeftButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"CameraLeftButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"CameraLeftButtonStyle"
		}

		"CameraLeftLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraLeftLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"CameraLeftName"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraLeftName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PAN LEFT"
			"style"					"KeyboardSettingsTitle"
		}

		"CameraDownButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"CameraDownButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"CameraDownButtonStyle"
		}

		"CameraDownLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraDownLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"CameraDownName"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraDownName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PAN DOWN"
			"style"					"KeyboardSettingsTitle"
		}

		"CameraRightButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"CameraRightButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"CameraRightButtonStyle"
		}

		"CameraRightLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraRightLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"CameraRightName"
		{
			"ControlName"			"Label"
			"fieldName"				"CameraRightName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PAN RIGHT"
			"style"					"KeyboardSettingsTitle"
		}
		
		//=====================================================================
		//
		// Hero Settings Keys
		//
		
		"HeroSettingsBackground"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"HeroSettingsBackground"
			"fillcolor"				"43 43 43 255"
			"zpos"					"4"
			"wide"					"336"
			"tall"					"248"
			"minimum-width"			"336"
			"minimum-height"		"248"
			"enabled"				"1"
			"visible"				"1"
		}

		"HeroAttackButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"HeroAttackButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HeroAttackButtonStyle"
		}

		"HeroAttackLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroAttackLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"HeroAttackName"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroAttackName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"ATTACK"
			"style"					"KeyboardSettingsTitle"
		}

		"HeroStopButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"HeroStopButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HeroStopButtonStyle"
		}

		"HeroStopLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroStopLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"HeroStopName"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroStopName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"STOP"
			"style"					"KeyboardSettingsTitle"
		}

		"HeroHomeButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"HeroHomeButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HeroHomeButtonStyle"
		}

		"HeroHomeLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroHomeLabel"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"HeroHomeName"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroHomeName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"HERO HOME"
			"style"					"KeyboardSettingsTitle"
		}

		"HeroSelectButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"HeroSelectButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HeroSelectButtonStyle"
		}

		"HeroSelectLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroSelectLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"HeroSelectName"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroSelectName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"HERO SELECT"
			"style"					"KeyboardSettingsTitle"
		}

		"HeroLockButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"HeroLockButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HeroLockButtonStyle"
		}

		"HeroLockLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroLockLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"HeroLockName"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroLockName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"HERO LOCK"
			"style"					"KeyboardSettingsTitle"
		}

		"HeroCycleButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"HeroCycleButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HeroCycleButtonStyle"
		}

		"HeroCycleLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroCycleLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"HeroCycleName"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroCycleName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"HERO CYCLE"
			"style"					"KeyboardSettingsTitle"
		}

		//=====================================================================
		//
		// Misc Settings Keys
		//
		
		"MiscSettingsBackground"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"MiscSettingsBackground"
			"fillcolor"				"43 43 43 255"
			"zpos"					"4"
			"wide"					"336"
			"tall"					"248"
			"minimum-width"			"336"
			"minimum-height"		"248"
			"enabled"				"1"
			"visible"				"1"
		}

		"ChatTeamButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ChatTeamButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"ChatTeamButtonStyle"
		}

		"ChatTeamLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ChatTeamLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ChatTeamName"
		{
			"ControlName"			"Label"
			"fieldName"				"ChatTeamName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"CHAT TEAM"
			"style"					"KeyboardSettingsTitle"
		}

		"ChatGlobalButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ChatGlobalButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"ChatGlobalButtonStyle"
		}

		"ChatGlobalLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ChatGlobalLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ChatGlobalName"
		{
			"ControlName"			"Label"
			"fieldName"				"ChatGlobalName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"CHAT GLOBAL"
			"style"					"KeyboardSettingsTitle"
		}

		"ChatVoiceButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ChatVoiceButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"ChatVoiceButtonStyle"
		}

		"ChatVoiceLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ChatVoiceLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
			
		"ChatVoiceName"
		{
			"ControlName"			"Label"
			"fieldName"				"ChatVoiceName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"VOICE"
			"style"					"KeyboardSettingsTitle"
		}
			
		"ScoreboardToggleButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ScoreboardToggleButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"ScoreboardToggleButtonStyle"
		}

		"ScoreboardToggleLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ScoreboardToggleLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ScoreboardToggleName"
		{
			"ControlName"			"Label"
			"fieldName"				"ScoreboardToggleName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"SCOREBOARD"
			"style"					"KeyboardSettingsTitle"
		}

		"ScreenshotSettingsButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ScreenshotSettingsButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"ScreenshotSettingsButtonStyle"
		}

		"ScreenshotSettingsLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ScreenshotSettingsLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ScreenshotSettingsName"
		{
			"ControlName"			"Label"
			"fieldName"				"ScreenshotSettingsName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"SCREENSHOT"
			"style"					"KeyboardSettingsTitle"
		}

		"FeedbackSettingsButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"FeedbackSettingsButton"
			"zpos"					"5"
			"wide"					"96"
			"tall"					"96"
			"minimum-width"			"96"
			"minimum-height"		"96"
			"enabled"				"1"
			"visible"				"1"
			"style"					"FeedbackSettingsButtonStyle"
		}

		"FeedbackSettingsLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"FeedbackSettingsLabel"
			"zpos"					"7"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"FeedbackSettingsName"
		{
			"ControlName"			"Label"
			"fieldName"				"FeedbackSettingsName"
			"zpos"					"6"
			"wide"					"96"
			"tall"					"16"
			"minimum-width"			"96"
			"minimum-height"		"16"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"FEEDBACK"
			"style"					"KeyboardSettingsTitle"
		}
		
		//=====================================================================
		//
		// Selection
		//

		"SelectionSettingsBackground"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"SelectionSettingsBackground"
			"fillcolor"				"43 43 43 255"
			"zpos"					"3"
			"wide"					"680"
			"tall"					"80"
			"minimum-width"			"680"
			"minimum-height"		"80"
			"enabled"				"1"
			"visible"				"1"
		}

 		"SelectionGroupsLabel"
 		{
			"ControlName"		"Label"
			"fieldName"			"SelectionGroupsLabel"
			"zpos"				"5"
			"wide"				"304"
			"tall"				"32"
			"minimum-width"		"304"
			"minimum-height"	"32"
			"enabled"			"1"	
			"visible"			"1"
			"textAlignment"		"west"
			"labelText"			"SELECT GROUPS (+CTRL TO CREATE)"
			"style"				"KeyboardSettingsTitle"
		}			

		"ControlGroup1Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ControlGroup1Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"ControlGroup1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"ControlGroup1Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"ControlGroup2Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ControlGroup2Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"ControlGroup2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"ControlGroup2Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"ControlGroup3Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ControlGroup3Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"ControlGroup3Label"
		{
			"ControlName"			"Label"
			"fieldName"				"ControlGroup3Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ControlGroup4Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ControlGroup4Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"ControlGroup4Label"
		{
			"ControlName"			"Label"
			"fieldName"				"ControlGroup4Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ControlGroup5Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ControlGroup5Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"ControlGroup5Label"
		{
			"ControlName"			"Label"
			"fieldName"				"ControlGroup5Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
 		"SelectionCamerasLabel"
 		{
			"ControlName"		"Label"
			"fieldName"			"SelectionCamerasLabel"
			"zpos"				"5"
			"wide"				"304"
			"tall"				"32"
			"minimum-width"		"304"
			"minimum-height"	"32"
			"enabled"			"1"	
			"visible"			"1"
			"textAlignment"		"west"
			"labelText"			"SELECT CAMERAS (+CTRL TO CREATE)"
			"style"				"KeyboardSettingsTitle"
		}			

		"Camera1Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Camera1Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"Camera1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Camera1Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"Camera2Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Camera2Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}

		"Camera2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Camera2Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"Camera3Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Camera3Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"SelectionButtonStyle"
		}
		
		"Camera3Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Camera3Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		//=========================================================================
		//
		// Abilities
		//

		"AbilitySectionLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionLabel"
			"zpos"					"6"
			"wide"					"450"
			"tall"					"48"
			"minimum-width"			"450"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"ABILITIES"
			"style"					"KeyboardSettingsTitle"
		}

		"AbilitySectionPrimary1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionPrimary1Label"
			"zpos"					"6"
			"wide"					"64"
			"tall"					"48"
			"minimum-width"			"64"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PRIMARY 1"
			"style"					"AbilitySectionButtons"
		}

		"AbilitySectionPrimary2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionPrimary2Label"
			"zpos"					"6"
			"wide"					"64"
			"tall"					"48"
			"minimum-width"			"64"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PRIMARY 2"
			"style"					"AbilitySectionButtons"
		}

		"AbilitySectionPrimary3Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionPrimary3Label"
			"zpos"					"6"
			"wide"					"64"
			"tall"					"48"
			"minimum-width"			"64"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"PRIMARY 3"
			"style"					"AbilitySectionButtons"
		}

		"AbilitySectionSecondary1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionSecondary1Label"
			"zpos"					"6"
			"wide"					"64"
			"tall"					"48"
			"minimum-width"			"64"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"SECONDARY 1"
			"style"					"AbilitySectionButtons"
		}

		"AbilitySectionSecondary2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionSecondary2Label"
			"zpos"					"6"
			"wide"					"64"
			"tall"					"48"
			"minimum-width"			"64"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"SECONDARY 2"
			"style"					"AbilitySectionButtons"
		}

		"AbilitySectionUltimateLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySectionUltimateLabel"
			"zpos"					"6"
			"wide"					"60"
			"tall"					"48"
			"minimum-width"			"60"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"ULTIMATE"
			"style"					"AbilitySectionButtons"
		}
		
		"AbilityPrimary1Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"AbilityPrimary1Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"AbilityButtonStyle"
		}

		"AbilityPrimary1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilityPrimary1Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"AbilityPrimary2Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"AbilityPrimary2Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"AbilityButtonStyle"
		}

		"AbilityPrimary2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilityPrimary2Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"AbilityPrimary3Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"AbilityPrimary3Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"AbilityButtonStyle"
		}

		"AbilityPrimary3Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilityPrimary3Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"AbilitySecondary1Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"AbilitySecondary1Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"AbilityButtonStyle"
		}

		"AbilitySecondary1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySecondary1Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"AbilitySecondary2Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"AbilitySecondary2Button"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"AbilityButtonStyle"
		}

		"AbilitySecondary2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilitySecondary2Label"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"AbilityUltimateButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"AbilityUltimateButton"
			"zpos"					"5"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"style"					"AbilityButtonStyle"
		}

		"AbilityUltimateLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"AbilityUltimateLabel"
			"zpos"					"6"
			"wide"					"48"
			"tall"					"48"
			"minimum-width"			"48"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		//
		// Inventory
		//
		"InventorySectionLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"InventorySectionLabel"
			"zpos"					"7"
			"wide"					"160"
			"tall"					"48"
			"minimum-width"			"160"
			"minimum-height"		"48"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				"INVENTORY"
			"style"					"KeyboardSettingsTitle"
		}
		
		"Inventory1Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Inventory1Button"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"InventoryButtonStyle"
		}

		"Inventory1Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Inventory1Label"
			"zpos"					"6"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"Inventory2Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Inventory2Button"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"InventoryButtonStyle"
		}

		"Inventory2Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Inventory2Label"
			"zpos"					"6"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"Inventory3Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Inventory3Button"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"InventoryButtonStyle"
		}

		"Inventory3Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Inventory3Label"
			"zpos"					"6"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"Inventory4Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Inventory4Button"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"InventoryButtonStyle"
		}

		"Inventory4Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Inventory4Label"
			"zpos"					"6"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"Inventory5Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Inventory5Button"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"InventoryButtonStyle"
		}

		"Inventory5Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Inventory5Label"
			"zpos"					"6"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		"Inventory6Button"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"Inventory6Button"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"InventoryButtonStyle"
		}

		"Inventory6Label"
		{
			"ControlName"			"Label"
			"fieldName"				"Inventory6Label"
			"zpos"					"6"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}

		//
		// Shop
		//
		"ShopToggleButton"
		{
			"ControlName"			"CDOTAKeyboardSettingsButton"
			"fieldName"				"ShopToggleButton"
			"xpos"					"890"
			"ypos"					"530"
			"zpos"					"5"
			"wide"					"32"
			"tall"					"32"
			"minimum-width"			"32"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"style"					"ShopButtonStyle"
		}

		"ShopToggleLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ShopToggleLabel"
			"xpos"					"890"
			"ypos"					"530"
			"zpos"					"6"
			"wide"					"32"
			"tall"					"32"
			"minimum-width"			"32"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"center"
			"labelText"				""
			"style"					"KeyboardSettingsText"
		}
		
		"ShopSectionLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"ShopSectionLabel"
			"xpos"					"926"
			"ypos"					"530"
			"zpos"					"5"
			"wide"					"40"
			"tall"					"32"
			"minimum-width"			"40"
			"minimum-height"		"32"
			"enabled"				"1"
			"visible"				"1"
			"textAlignment"			"west"
			"labelText"				"SHOP"
			"style"					"KeyboardSettingsTitle"
		}
		
		//
		// HUD
		//
		"HUDLeftImage"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"HUDLeftImage"
			"zpos"					"4"
			"wide"					"190"
			"tall"					"175"
			"minimum-width"			"190"
			"minimum-height"		"175"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HUDLeftStyle"
		}

		"HUDMiddleImage"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"HUDMiddleImage"
			"zpos"					"4"
			"wide"					"640"
			"tall"					"175"
			"minimum-width"			"640"
			"minimum-height"		"175"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HUDMiddleStyle"
		}

		"HUDRightImage"
		{
			"ControlName"			"ImagePanel"
			"fieldName"				"HUDRightImage"
			"zpos"					"4"
			"wide"					"194"
			"tall"					"175"
			"minimum-width"			"194"
			"minimum-height"		"175"
			"enabled"				"1"
			"visible"				"1"
			"style"					"HUDRightStyle"
		}
	}
		
	colors
	{
		"KeyboardTitleColor"		"149 149 149 255"
		"KeyboardTextColor"			"0 0 0 255"
		"KeyboardButtonLight"		"140 140 140 255"
		"KeyboardResetButtonColor"	"207 207 207 255"
		"KeyboardBackground"		"43 43 43 255"
	}
	
	styles
	{
		"KeyboardBackground"
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_bg_settings.vmat )"
			}
		}
	
		"KeyboardSettingsTitle"
		{
			textcolor=KeyboardTitleColor
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}

		"AbilitySectionButtons"
		{
			textcolor=KeyboardTitleColor
			font=Arial10Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}

		"KeyboardSettingsText"
		{
			textcolor=KeyboardTextColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}

		// HUD
		HUDLeftStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_hud_left.vmat)" } }
		HUDMiddleStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_hud_middle_six_nolabels.vmat)" } }
		HUDRightStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_hud_right.vmat)" } }
		
		// Base		
		BaseButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg.vmat)" } }
		BaseButtonStyle:hover { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed.vmat)"  } }
		BaseButtonStyle:active { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_override.vmat)" } }

		ResetButtonStyle { textcolor=KeyboardResetButtonColor font=Arial14Thick bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard\dash_tab_normal.vmat)" } }
		ResetButtonStyle:hover { textcolor=KeyboardResetButtonColor font=Arial14Thick bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard\dash_tab_hover.vmat)"  } }
		
		// Camera Icons
		CameraHomeButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_base.vmat)" } }
		CameraHomeButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_base.vmat)" } }
		CameraHomeButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_base.vmat)" } }

		CameraUpButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_up.vmat)" } }
		CameraUpButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_up.vmat)" } }
		CameraUpButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_up.vmat)" } }

		CameraGripButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_grip.vmat)" } }
		CameraGripButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_grip.vmat)" } }
		CameraGripButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_grip.vmat)" } }

		CameraLeftButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_left.vmat)" } }
		CameraLeftButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_left.vmat)" } }
		CameraLeftButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_left.vmat)" } }

		CameraDownButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_down.vmat)" } }
		CameraDownButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_down.vmat)" } }
		CameraDownButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_down.vmat)" } }

		CameraRightButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_right.vmat)" } }
		CameraRightButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_right.vmat)" } }
		CameraRightButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_pan_right.vmat)" } }

// 		CameraPlace1ButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_one.vmat)" } }
// 		CameraPlace1ButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_one.vmat)" } }
// 		CameraPlace1ButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_one.vmat)" } }
// 
// 		CameraPlace2ButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_two.vmat)" } }
// 		CameraPlace2ButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_two.vmat)" } }
// 		CameraPlace2ButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_two.vmat)" } }
// 
// 		CameraPlace3ButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_three.vmat)" } }
// 		CameraPlace3ButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_three.vmat)" } }
// 		CameraPlace3ButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_three.vmat)" } }

		// Hero Icons
		HeroAttackButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg.vmat)" } }
		HeroAttackButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed.vmat)" } }
		HeroAttackButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed_override.vmat)" } }

		HeroStopButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg.vmat)" } }
		HeroStopButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed.vmat)" } }
		HeroStopButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed_override.vmat)" } }

		HeroHomeButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg.vmat)" } }
		HeroHomeButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed.vmat)" } }
		HeroHomeButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed_override.vmat)" } }

		HeroLockButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_hero_lock.vmat)" } }
		HeroLockButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_hero_lock.vmat)" } }
		HeroLockButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_hero_lock.vmat)" } }

		HeroSelectButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_hero_center.vmat)" } }
		HeroSelectButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_hero_center.vmat)" } }
		HeroSelectButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_cam_hero_center.vmat)" } }

		HeroCycleButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_selection_cycle.vmat)" } }
		HeroCycleButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_selection_cycle.vmat)" } }
		HeroCycleButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_selection_cycle.vmat)" } }

		// Chat Icons
		ChatTeamButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_team.vmat)" } }
		ChatTeamButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_team.vmat)" } }
		ChatTeamButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_team.vmat)" } }

		ChatGlobalButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_global.vmat)" } }
		ChatGlobalButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_global.vmat)" } }
		ChatGlobalButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_global.vmat)" } }

		ChatVoiceButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_voice.vmat)" } }
		ChatVoiceButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_voice.vmat)" } }
		ChatVoiceButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_chat_voice.vmat)" } }

		ScoreboardToggleButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_scoreboard.vmat)" } }
		ScoreboardToggleButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_scoreboard.vmat)" } }
		ScoreboardToggleButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_scoreboard.vmat)" } }

		ScreenshotSettingsButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg.vmat)" } }
		ScreenshotSettingsButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed.vmat)" } }
		ScreenshotSettingsButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed_override.vmat)" } }

		FeedbackSettingsButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg.vmat)" } }
		FeedbackSettingsButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed.vmat)" } }
		FeedbackSettingsButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_bg_pressed_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_bg_pressed_override.vmat)" } }
		
		//
		// Selection
		//
		SelectionButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number.vmat)" } }
		SelectionButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_highlight)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_highlight.vmat)" } }
		SelectionButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_override.vmat)" } }

		//
		// Abilities
		//
		AbilityButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number.vmat)" } }
		AbilityButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_highlight)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_highlight.vmat)" } }
		AbilityButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_override.vmat)" } }

		//
		// Inventory
		//
		InventoryButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number.vmat)" } }
		InventoryButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_highlight)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_highlight.vmat)" } }
		InventoryButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_override.vmat)" } }

		//
		// Shop
		//
		ShopButtonStyle { bgcolor=none render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number.vmat)" } }
		ShopButtonStyle:hover { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_highlight)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_highlight.vmat)" } }
		ShopButtonStyle:active { bgcolor=none	render_bg{ 0="image_scale(x0,y0,x1,y1,settings\settings_bindings_button_number_override)" 1="image_scale(x0,y0,x1,y1,materials/vgui/settings\settings_bindings_button_number_override.vmat)" } }
	}
	
	Layout
	{
		// Base Binding Settings
		Region { name=BaseBindingSettingsRegion x=0 y=0 width=160 height=48 }
		Place { Region=BaseBindingSettingsRegion x=0 y=0 Margin-Left=8 Margin-Top=8 Controls=BaseBindingSettingsBackground }
		Place { Region=BaseBindingSettingsRegion x=0 y=0 Margin-Left=9 Margin-Top=9 Controls=KeyboardSettingsResetButton }
	
		// HUD Settings
		Region { name=HUDSettingsRegion x=0 y=497 width=1024 height=175 }
		Place { Region=HUDSettingsRegion Dir=Right x=0 y=0 Controls=HUDLeftImage,HUDMiddleImage,HUDRightImage }
		
		// Hero Selection Settings		
		Region { name=HeroSelectionSettingsRegion x=160 y=0 width=864 height=48 }
		Place { Region=HeroSelectionSettingsRegion x=0 y=0 Margin-Top=8 width=856 height=32 Controls=HeroSelectionSettingsBackground }
		Place { Region=HeroSelectionSettingsRegion x=0 y=0 Margin-Left=8 Margin-Top=8 width=160 height=32 Controls=HeroOverridesLabel }
		Place { Region=HeroSelectionSettingsRegion x=0 y=0 Margin-Top=8 width=856 height=32 Controls=HeroOverridesLabelTemp }
	
		// Camera Settings
		Region { name=CameraSettingsRegion x=8 y=48 width=336 height=248 }
		Place { Region=CameraSettingsRegion x=0 y=0 width=336 height=248 Controls=CameraSettingsBackground }
		Place { Region=CameraSettingsRegion x=0 y=0 Dir=Right Margin-Left=24 Margin-Top=8 Spacing=8 Controls=CameraHomeButton,CameraUpButton,CameraGripButton }
		Place { Region=CameraSettingsRegion x=0 y=0 Dir=Right Margin-Left=24 Margin-Top=8 Spacing=8 Controls=CameraHomeLabel,CameraUpLabel,CameraGripLabel }
		Place { Region=CameraSettingsRegion x=0 y=104 Dir=Right Margin-Left=24 Spacing=8 Controls=CameraHomeName,CameraUpName,CameraGripName }
		Place { Region=CameraSettingsRegion x=0 y=120 Dir=Right Margin-Left=24 Margin-Top=8 Spacing=8 Controls=CameraLeftButton,CameraDownButton,CameraRightButton }
		Place { Region=CameraSettingsRegion x=0 y=120 Dir=Right Margin-Left=24 Margin-Top=8 Spacing=8 Controls=CameraLeftLabel,CameraDownLabel,CameraRightLabel }
		Place { Region=CameraSettingsRegion x=0 y=224 Dir=Right Margin-Left=24 Spacing=8 Controls=CameraLeftName,CameraDownName,CameraRightName }

		// Hero Settings
		Region { name=HeroSettingsRegion x=344 y=48 width=336 height=248 }
		Place { Region=HeroSettingsRegion x=0 y=0 width=336 height=248 Controls=HeroSettingsBackground }
		Place { Region=HeroSettingsRegion x=0 y=0 Dir=Right Margin-Left=16 Margin-Top=8 Spacing=8 Controls=HeroAttackButton,HeroStopButton,HeroHomeButton }
		Place { Region=HeroSettingsRegion x=0 y=0 Dir=Right Margin-Left=16 Margin-Top=8 Spacing=8 Controls=HeroAttackLabel,HeroStopLabel,HeroHomeLabel }
		Place { Region=HeroSettingsRegion x=0 y=104 Dir=Right Margin-Left=16 Spacing=8 Controls=HeroAttackName,HeroStopName,HeroHomeName }
		Place { Region=HeroSettingsRegion x=0 y=120 Dir=Right Margin-Left=16 Margin-Top=8 Spacing=8 Controls=HeroSelectButton,HeroLockButton,HeroCycleButton }
		Place { Region=HeroSettingsRegion x=0 y=120 Dir=Right Margin-Left=16 Margin-Top=8 Spacing=8 Controls=HeroSelectLabel,HeroLockLabel,HeroCycleLabel }
		Place { Region=HeroSettingsRegion x=0 y=224 Dir=Right Margin-Left=16 Spacing=8 Controls=HeroSelectName,HeroLockName,HeroCycleName }

		// Misc Region
		Region { name=MiscSettingsRegion x=680 y=48 width=336 height=248 }
		Place { Region=MiscSettingsRegion x=0 y=0 width=336 height=248 Controls=MiscSettingsBackground }
		Place { Region=MiscSettingsRegion x=0 y=0 Dir=Right Margin-Left=8 Margin-Top=8 Spacing=8 Controls=ChatTeamButton,ChatGlobalButton,ChatVoiceButton }		
		Place { Region=MiscSettingsRegion x=0 y=0 Dir=Right Margin-Left=8 Margin-Top=8 Spacing=8 Controls=ChatTeamLabel,ChatGlobalLabel,ChatVoiceLabel }
		Place { Region=MiscSettingsRegion x=0 y=104 Dir=Right Margin-Left=8 Spacing=8 Controls=ChatTeamName,ChatGlobalName,ChatVoiceName }
		Place { Region=MiscSettingsRegion x=0 y=120 Dir=Right Margin-Left=8 Margin-Top=8 Spacing=8 Controls=ScoreboardToggleButton,ScreenshotSettingsButton,FeedbackSettingsButton }
		Place { Region=MiscSettingsRegion x=0 y=120 Dir=Right Margin-Left=8 Margin-Top=8 Spacing=8 Controls=ScoreboardToggleLabel,ScreenshotSettingsLabel,FeedbackSettingsLabel }
		Place { Region=MiscSettingsRegion x=0 y=224 Dir=Right Margin-Left=8 Spacing=8 Controls=ScoreboardToggleName,ScreenshotSettingsName,FeedbackSettingsName }

		// Selection Region
 		Region { name=SelectionSettingsRegion x=8 y=304 width=680 height=80 }
 		Place { Region=SelectionSettingsRegion x=0 y=0 width=680 height=80 Controls=SelectionSettingsBackground }
 		Place { Region=SelectionSettingsRegion x=26 y=0 Controls=SelectionGroupsLabel }
 		Place { Region=SelectionSettingsRegion x=20 y=26 Dir=Right Spacing=0 Controls=ControlGroup1Button,ControlGroup2Button,ControlGroup3Button,ControlGroup4Button,ControlGroup5Button }
 		Place { Region=SelectionSettingsRegion x=20 y=26 Dir=Right Spacing=0 Controls=ControlGroup1Label,ControlGroup2Label,ControlGroup3Label,ControlGroup4Label,ControlGroup5Label }
 		Place { Region=SelectionSettingsRegion x=355 y=0 Controls=SelectionCamerasLabel }
 		Place { Region=SelectionSettingsRegion x=350 y=26 Dir=Right Spacing=0 Controls=Camera1Button,Camera2Button,Camera3Button }
 		Place { Region=SelectionSettingsRegion x=350 y=26 Dir=Right Spacing=0 Controls=Camera1Label,Camera2Label,Camera3Label }
 		 				
		// Ability Region
		Region { name=AbilitySettingsRegion x=360 y=542 width=450 height=134 }
		Place { Region=AbilitySettingsRegion x=0 y=0 Dir=Right Margin-Left=8 Margin-Top=8 Spacing=25 Controls=AbilityPrimary1Button,AbilityPrimary2Button,AbilityPrimary3Button,AbilitySecondary1Button,AbilitySecondary2Button,AbilityUltimateButton }
		Place { Region=AbilitySettingsRegion x=0 y=0 Dir=Right Margin-Left=8 Margin-Top=8 Spacing=25 Controls=AbilityPrimary1Label,AbilityPrimary2Label,AbilityPrimary3Label,AbilitySecondary1Label,AbilitySecondary2Label,AbilityUltimateLabel }
		Place { Region=AbilitySettingsRegion x=17 y=70 Dir=Right Spacing=10 Controls=AbilitySectionPrimary1Label,AbilitySectionPrimary2Label,AbilitySectionPrimary3Label }
		Place { Region=AbilitySettingsRegion x=237 y=70 Dir=Right Spacing=10 Controls=AbilitySectionSecondary1Label,AbilitySectionSecondary2Label,AbilitySectionUltimateLabel }
		Place { Region=AbilitySettingsRegion x=0 y=80 Margin-Left=8 Margin-Top=8 Controls=AbilitySectionLabel }

		// Inventory Region
		Region { name=InventorySettingsRegion x=835 y=568 width=160 height=160 }
		Place { Region=InventorySettingsRegion x=0 y=0 Dir=Right Spacing=20 Controls=Inventory1Button,Inventory2Button,Inventory3Button }
		Place { Region=InventorySettingsRegion x=0 y=0 Dir=Right Spacing=20 Controls=Inventory1Label,Inventory2Label,Inventory3Label }
		Place { Region=InventorySettingsRegion x=0 y=35 Dir=Right Spacing=20 Controls=Inventory4Button,Inventory5Button,Inventory6Button }
		Place { Region=InventorySettingsRegion x=0 y=35 Dir=Right Spacing=20 Controls=Inventory4Label,Inventory5Label,Inventory6Label }		
		Place { Region=InventorySettingsRegion x=0 y=54 Margin-Left=8 Margin-Top=8 Controls=InventorySectionLabel }
	}
			
	include="resource/UI/settings_style.res"		
}