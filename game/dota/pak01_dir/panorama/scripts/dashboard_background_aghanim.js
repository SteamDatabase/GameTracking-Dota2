const EVENT_ID_FALL_2021 = 33;
var g_bDetailsVisible = false;

const k_modelInfos = 
[
	{	// Default Aghs
		entityName : "aghanim_01"
	},
	{	// Beastmaster Aghs
		entityName : "aghanim_02",
		unlockAction : "aghs_model_unlocked_beastmaster"
	},
	{	// Bubble Bath Aghs
		entityName : "aghanim_03",
		unlockAction : "aghs_model_unlocked_bubble_bath"
	},
	{	// Mechanic Aghs
		entityName : "aghanim_04",
		customSounds : [ "Aghanim.LotsOfHobbies" ],
		unlockAction : "aghs_model_unlocked_mechanic"
	},
	{	// Bucket Aghs
		entityName : "aghanim_05",
		customSounds : [ "Aghanim.BucketEntrance" ],
		unlockAction : "aghs_model_unlocked_bucket"
	},
	{	// Bro Aghs
		entityName : "aghanim_06",
		customSounds : [ "Aghanim.BroEntrance" ],
		unlockAction : "aghs_model_unlocked_bro"
	},
	{	// Goat Aghs
		entityName : "aghanim_07",
		customSounds : [ "Aghanim.GoatEntrance" ],
		unlockAction : "aghs_model_unlocked_goat"
	},
	{	// Mad Max Aghs
		entityName : "aghanim_08",
		unlockAction : "aghs_model_unlocked_mad_max"
	},
	{	// Future Aghs
		entityName : "aghanim_09",
		customSounds : [ "Aghanim.MechEntrance" ],
		unlockAction : "aghs_model_unlocked_future"
	},
	{	// Roshan Aghs
		entityName : "aghanim_10",
		unlockAction : "aghs_model_unlocked_roshan"
	},
	{	// Courier Aghs
		entityName : "aghanim_11",
		unlockAction : "aghs_model_unlocked_courier"
	},
];

const k_genericSounds = 
[
	"Aghanim.BingBong_01",
	"Aghanim.BingBong_02",
	"Aghanim.BingBong_03",
	"Aghanim.BoopityBop_01",
	"Aghanim.BoopityBop_02",
	"Aghanim.BoopityBop_03",
	"Aghanim.Booyah",
	"Aghanim.CheckOutTheHustle",
	"Aghanim.CheckOutThisGuy",
	"Aghanim.FlickOfTheWrist",
	"Aghanim.Hiyahh_01",
	"Aghanim.Hiyahh_02",
	"Aghanim.Hiyahh_03",
	"Aghanim.Hiyahh_04",
	"Aghanim.LookWhoItIs",
	"Aghanim.Shazaam",
	"Aghanim.SmallBusinessOwner",
];

var IsModelUnlocked = function( nIndex )
{
	if ( nIndex < 0 || nIndex >= k_modelInfos.length )
		return false;

	if ( k_modelInfos[ nIndex ].unlockAction == undefined )
		return true;

	return $.GetContextPanel().RequestActionScoreByName( k_modelInfos[ nIndex ].unlockAction ) > 0;
}

var UpdateUnlockIcons = function()
{
	var unlockIcons = $( '#UnlockIcons' );
	for ( var i = 0; i < unlockIcons.GetChildCount() && i < k_modelInfos.length; ++i )
	{
		var unlockIcon = unlockIcons.GetChild( i );
		unlockIcon.SetHasClass( 'ModelUnlocked', IsModelUnlocked( i ) );
		unlockIcon.checked = ( i == g_nCurrentModelIndex );
	}
}

$.Schedule( 0.0, function()
{
	var unlockIcons = $( '#UnlockIcons' );
	unlockIcons.RemoveAndDeleteChildren();

	for ( var i = 0; i < k_modelInfos.length; ++i )
	{
		var unlockIcon = $.CreatePanel( 'Panel', unlockIcons, 'UnlockIcon' + i );
		unlockIcon.BLoadLayoutSnippet( 'UnlockIcon' );
	}  

	UpdateUnlockIcons();
} );

var UpdateSelectedModelUnlocked = function()
{
	$.GetContextPanel().SetHasClass( 'SelectedModelUnlocked', IsModelUnlocked( g_nCurrentModelIndex ) );
}

var g_nCurrentModelIndex = -1;
var g_nSoundCookie = 0;
var g_bPlayingVoiceoverSound = false;
var SetCurrentModel = function( nModelIndex, bPlaySound )
{
	// $.Msg( 'SetCurrentModel ' + nModelIndex + " " + bPlaySound );
	if ( g_nCurrentModelIndex == nModelIndex )
		return;

	g_nCurrentModelIndex = nModelIndex;

	var aghanimModel = $( '#AghanimModel' );

	for ( var i = 0; i < k_modelInfos.length; ++i )
	{
		if( i === g_nCurrentModelIndex )
		{
			aghanimModel.FireEntityInput( k_modelInfos[ i ].entityName, "TurnOn", '' );
			//$.Msg("Turning on " + k_modelInfos[ i ].entityName );
			if (i == 4) //bucket
			{
				aghanimModel.FireEntityInput( "aghanim_05_stool", "TurnOn", '' );
			}

			aghanimModel.SetHasClass( 'CourierShown', i == 10 );
		}
		else
		{
			aghanimModel.FireEntityInput(  k_modelInfos[ i ].entityName, "TurnOff", '' );
			//$.Msg("Turning off " +  k_modelInfos[ i ].entityName );
			if (i == 4)
			{
				aghanimModel.FireEntityInput( "aghanim_05_stool", "TurnOff", '' );
			}
		}
	}

	UpdateUnlockIcons();
	UpdateSelectedModelUnlocked();

	if ( bPlaySound )
	{
		// Always play the continuum device sound
		PlayUISoundScript( "ContinuumDevice.Activate" );

		if ( IsModelUnlocked( g_nCurrentModelIndex ) )
		{
		
			g_nSoundCookie = g_nSoundCookie + 1;

			// Wait one second in case they're spam clicking, then try to play a voiceover sound
			$.Schedule( 0.8, ( function( nCookie )
			{
				return function()
				{
					if ( nCookie != g_nSoundCookie )
						return;

					if ( g_bPlayingVoiceoverSound )
						return;

					// Choose from the generic sounds or if this model has something specific.
					var soundOptions = k_genericSounds;
					if ( k_modelInfos[ g_nCurrentModelIndex ].customSounds )
					{
						soundOptions = soundOptions.concat( k_modelInfos[ g_nCurrentModelIndex ].customSounds );
					}
			
					var nIndex = Math.floor( Math.random() * soundOptions.length );
					var voSound = soundOptions[ nIndex ];
			
					g_bPlayingVoiceoverSound = true;
			
					var seq = new RunSequentialActions();
					seq.actions.push( new PlaySoundUntilFinishedAction( voSound ) );
					seq.actions.push( new RunFunctionAction( function() { g_bPlayingVoiceoverSound = false; } ) );
					RunSingleAction( seq );

				};
			} )( g_nSoundCookie ) );
		}
	}
}

var SetToNextModel = function()
{
	SetCurrentModel( ( g_nCurrentModelIndex + 1 ) % k_modelInfos.length, true );
}

var MaybeUpdateInitalModel = function()
{
	if ( g_nCurrentModelIndex != -1 )
		return;

	if ( !$.GetContextPanel().HasEventData() )
		return;

	var aghanimModel = $( '#AghanimModel' );
	if ( !aghanimModel.BHasClass( 'SceneLoaded' ) )
		return;

	var possibleModelIndices = [];
	for ( var i = 0; i < k_modelInfos.length; ++i )
	{
		if ( IsModelUnlocked( i ) )
		{
			possibleModelIndices.push( i );
		}
	}

	if ( possibleModelIndices.length == 0 )
	{
		$.Msg( "Error, no unlocked models?" );
		return;
	}

	var nSelectedIndex = Math.floor( Math.random() * possibleModelIndices.length );
	SetCurrentModel( possibleModelIndices[ nSelectedIndex ], false );

	$( '#AghanimModel' ).AddClass( 'Initialized' );
}

$.RegisterEventHandler( 'DOTAScenePanelSceneUnloaded', $( '#AghanimModel' ), function()
{
	g_nCurrentModelIndex = -1;
	$( '#AghanimModel' ).RemoveClass( 'Initialized' );
} );

$.RegisterEventHandler( 'DOTAScenePanelSceneLoaded', $( '#AghanimModel' ), function()
{
	// Need to do this the next frame, because adding the SceneLoaded
	// class happens after this event fires.
	$.Schedule( 0.0, function() {
		MaybeUpdateInitalModel();
	} );
} );

$.RegisterForUnhandledEvent( 'DOTAEventDataUpdated', function( eEvent )
{
	if ( eEvent != EVENT_ID_FALL_2021 )
		return false;

	MaybeUpdateInitalModel();
	UpdateUnlockIcons();
	UpdateSelectedModelUnlocked();

	return false;
} );



var OnAghanimDeviceMouseOver = function()
{
	//$.Msg("Aghanim Device MouseOver");

	 var deviceModel = $( '#DeviceModel' );
	 var aghanimModel = $( '#AghanimModel' );
	 deviceModel.SetAnimgraphParameterOnEntityInt( 'conundrum', 'mouseover', 1 );
	 deviceModel.FireEntityInput( 'device_spin_fx', 'start', 0 );
	 aghanimModel.FireEntityInput( 'device_spin_fx', 'start', 0 );

	$.GetContextPanel().AddClass( 'DeviceMouseOver' );
}

var OnAghanimDeviceMouseOut = function()
{
	//$.Msg("Aghanim Device MouseOut");

	var aghanimModel = $( '#AghanimModel' );
	 var deviceModel = $( '#DeviceModel' );
	 
	 deviceModel.SetAnimgraphParameterOnEntityInt( 'conundrum', 'mouseover', 0 );
	 deviceModel.FireEntityInput( 'device_active_fx', 'stop', 0 );
	 deviceModel.FireEntityInput( 'device_spin_fx', 'stop', 0 );
	 aghanimModel.FireEntityInput( 'device_spin_fx', 'stop', 0 );

	$.GetContextPanel().RemoveClass( 'DeviceMouseOver' );
}

var OnAghanimDeviceActivate = function()
{
	//$.Msg("Aghanim Device Activate " );

	var aghanimModel = $( '#AghanimModel' );
	var deviceModel = $( '#DeviceModel' );
	var ModelContainer = $( '#BackgroundModelsRef' );

	var ModelHelp = $( '#ModelHelp' );
	
	deviceModel.SetAnimgraphParameterOnEntityInt( 'conundrum', 'mouseover', 2 );
	deviceModel.FireEntityInput( 'device_active_fx', 'stop', 0 );
	deviceModel.FireEntityInput( 'device_active_fx', 'start', 0 );
	deviceModel.FireEntityInput( 'device_spin_fx', 'stop', 0 );
	aghanimModel.FireEntityInput( 'device_spin_fx', 'stop', 0 );

	ModelContainer.RemoveClass( "HelpMe" );
	
	var SpeechChoice = [ 
		"DOTA_Aghanim_FrontPageSpeech1",
		"DOTA_Aghanim_FrontPageSpeech2",
		"DOTA_Aghanim_FrontPageSpeech3",
		"DOTA_Aghanim_FrontPageSpeech4",
		"DOTA_Aghanim_FrontPageSpeech5",
		"DOTA_Aghanim_FrontPageSpeech6",
		"DOTA_Aghanim_FrontPageSpeech7",
		"DOTA_Aghanim_FrontPageSpeech8",
		"DOTA_Aghanim_FrontPageSpeech9",
		"DOTA_Aghanim_FrontPageSpeech10" ];

	/*Barb: Save us!
	Bath: Bring a towel!
	Tinker: Useless idiots.
	Bucket: What are you?!
	Dude: Far out!
	Goat: Baaah!
	Mad Maghs: This is your fault!
	Cyber Aghs: Recalibrating...
	Roshanaghanim: ...
	Aghanim the Wisest: What a pack of donkeys...*/

	nCurrentModelIndex = g_nCurrentModelIndex;
	$.Schedule(0.1, function () { ModelContainer.AddClass( "HelpMe" ); ModelHelp.text = SpeechChoice[ nCurrentModelIndex ]; });

	SetToNextModel();
}

var SetDetailsVisible = function( bVisible )
{
	$.GetContextPanel().SetHasClass( 'DetailsVisible', bVisible );
}

var ToggleDetailsVisible = function()
{
	//$.Msg("Details Clicked" );

	$.GetContextPanel().ToggleClass( 'DetailsVisible' );

	var aghanimModel = $( '#AghanimModel' );
	var deviceModel = $( '#DeviceModel' );
	
	g_bDetailsVisible = !g_bDetailsVisible;

	if ( g_bDetailsVisible ) 
	{
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'AghanimModel', 'hero_camera_details', 0.8 ); 
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'DeviceModel', 'hero_camera_device_details', 0.8 ); 
	}
	else
	{
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'AghanimModel', 'hero_camera', 0.8 ); 
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'DeviceModel', 'hero_camera', 0.8 ); 
	}
}


