
var g_seq;
var g_Stinger_SoundId;
var g_SFX_SoundId;

var RunPageAnimation = function ()
{
    g_seq = new RunSequentialActions();
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');

    $( '#ModelContainer' ).RemoveAndDeleteChildren();
    $( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );
    
    $( '#ModelBackground' ).RemoveClass( 'Initialize' );
    $( '#ModelBackgroundAlt' ).RemoveClass( 'Initialize' );

    $( '#SecondStyle' ).RemoveClass( 'Initialize' );
    $( '#DefaultStyle' ).RemoveClass( 'Initialize' ); 

    g_seq.actions.push( new WaitAction( 0.01 ) );
    g_seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
    g_seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
    
    g_seq.actions.push( new RunFunctionAction( function () { g_Stinger_SoundId = PlayUISoundScript( 'spectre_arc_debut_stinger'); }))
    //g_seq.actions.push(new RunFunctionAction( function () { g_SFX_SoundId = PlayUISoundScript( 'spectre_arc_debut_sfx'); } ) )
    g_seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
    g_seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
    g_seq.actions.push( new AddClassAction( $( '#ModelBackgroundAlt' ), 'Initialize' ) );

    g_seq.actions.push( new LerpDepthOfFieldAction( $( '#ModelBackground' ), "herocamera", 275, 300, 310, 325, 150, 275, 325, 800, 4.0 ) );
    g_seq.actions.push( new LerpDepthOfFieldAction( $( '#ModelBackgroundAlt' ), "herocamera", 275, 300, 310, 325, 150, 275, 325, 800, 4.0 ) );

    g_seq.actions.push(new WaitAction(4.20));
    g_seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
    g_seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );

    g_seq.actions.push( new WaitAction( 3.5 ) );
    g_seq.actions.push( new AddClassAction( $( '#SecondStyle' ), 'Initialize' ) );
    g_seq.actions.push( new AddClassAction( $( '#DefaultStyle' ), 'Initialize' ) );

    g_seq.actions.push( new RunFunctionAction( function() 
    {
        $('#ModelBackground').SetRotateParams( -0.75, 0.75, -0.75, 0.75 );
        $('#ModelBackgroundAlt').SetRotateParams( -0.75, 0.75, -0.75, 0.75 );
    }));


    RunSingleAction( g_seq );
}

function alternateStyle()
{
    $.GetContextPanel().AddClass('ShowingAlternateStyle');
}

function originalStyle()
{
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
}

function reloadSpectreArcanaDebutPage() 
{
    $.DispatchEvent('DOTAReloadCurrentPage');
}

function onLeaveSpectreArcanaDebutPage()
{
    if( g_seq )
    {
        g_seq.finish();
    }

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
}
