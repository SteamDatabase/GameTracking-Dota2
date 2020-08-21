
var g_seq;
var g_Stinger_SoundId;
var g_SFX_SoundId;

// VO Anim lengths, used as part of delay before next anim should play.
// These are dereived from the anims themselves from antimage_female model
// The anims start with 2, so 0 and 1 are set to 0
//    12.33,      // 2
//    8.33,       // 3
//    8.33,       // 4
//    14.66,      // 5
//    14.66,      // 6
//    3.33,       // 7
//    3.0,        // 8
//    2.33,       // 9
//    6.33,       // 10
//    2.5,        // 11
//    3.0,        // 12
//    4.83        // 13

var showcaseCameraMovement = function (cameraPos)
{
    $.Msg("Camera position = " + cameraPos);
    if (cameraPos === 1) {
        $('#ModelBackground').FireEntityInput('camera_driver', 'SetAnimation', 'pudge_cute_camera_anim_intro');
		//$('#ModelBackground').FireEntityInput('fly_model', 'SetAnimation', 'pudge_cute_fly');

    }
    if (cameraPos === 2) {
        $('#DebutInformation').RemoveClass('Initialize');
        
    }
	    if (cameraPos === 3) {
        $('#ModelBackground').FireEntityInput('camera_driver', 'SetAnimation', 'pudge_cute_camera_anim');
        
    }
}

var RunPageAnimation = function ()
{
    g_seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );

	g_seq.actions.push( new WaitAction( 0.01 ) );
    g_seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
    g_seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
    g_seq.actions.push(new RunFunctionAction( function () { g_Stinger_SoundId = PlayUISoundScript( 'pudge_persona_debut_stinger'); }))
    g_seq.actions.push(new RunFunctionAction( function () { g_SFX_SoundId = PlayUISoundScript( 'pudge_persona_debut_sfx'); } ) )
	g_seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	g_seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );

    g_seq.actions.push( new LerpDepthOfFieldAction( $( '#ModelBackground' ), "herocamera", 275, 300, 310, 325, 150, 275, 325, 800, 4.0 ) );
    
    g_seq.actions.push(new WaitAction(4.00));
	g_seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	g_seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
    //g_seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
	//g_seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	//g_seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );

    //g_seq.actions.push(new WaitAction(1.00));

    //g_seq.actions.push( new RunFunctionAction( function() 
	//{
	//    $('#ModelBackground').SetRotateParams( -1, 1, -1, 1 );
	//}));

    g_seq.actions.push( new RunFunctionAction( function() 
	{
	    $('#ModelBackground').SetRotateParams( -1, 1, -1, 1 );
	}));


    RunSingleAction( g_seq );
}

function closePudgePersonaDebutPage() {
    g_seq.finish();

    if ( g_Stinger_SoundId !== undefined )
    {
        StopUISoundScript( g_Stinger_SoundId );
    }
    if ( g_SFX_SoundId !== undefined )
    {
        StopUISoundScript( g_SFX_SoundId );
    }

    $('#MainContainer').RemoveClass('Initialize');
    $('#ModelBackground').RemoveClass('Initialize');
    $('#DebutInformation').RemoveClass('Initialize');
    $('#InformationBody').RemoveClass('Initialize');
    //$( '#ItemName' ).RemoveClass( 'Initialize' );
	//$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	//$( '#ItemLore' ).RemoveClass( 'Initialize' );

    $.DispatchEvent('DOTAShowHomePage');
}
