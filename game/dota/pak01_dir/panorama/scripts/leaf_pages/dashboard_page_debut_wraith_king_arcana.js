var g_nCurrentVoiceLine = 0;

// Action to animate an integer dialog variable over some duration of seconds
function LerpRotateAction(panel, yawMinStart, yawMaxStart, pitchMinStart, pitchMaxStart, yawMinEnd, yawMaxEnd, pitchMinEnd, pitchMaxEnd, seconds) {
    this.panel = panel;
    this.yawMinStart = yawMinStart;
    this.yawMaxStart = yawMaxStart;
    this.pitchMinStart = pitchMinStart;
    this.pitchMaxStart = pitchMaxStart;
    this.yawMinEnd = yawMinEnd;
    this.yawMaxEnd = yawMaxEnd;
    this.pitchMinEnd = pitchMinEnd;
    this.pitchMaxEnd = pitchMaxEnd;
    this.seconds = seconds;
}
LerpRotateAction.prototype = new BaseAction();
LerpRotateAction.prototype.start = function () {
    this.startTimestamp = Date.now();
    this.endTimestamp = this.startTimestamp + this.seconds * 1000;
}
LerpRotateAction.prototype.update = function () {
    var now = Date.now();
    if (now >= this.endTimestamp)
        return false;

	var ratio = (now - this.startTimestamp) / (this.endTimestamp - this.startTimestamp);
	
	if ( !this.panel )
	{
		this.panel.SetRotateParams(
			Lerp(ratio, this.yawMinStart, this.yawMinEnd),
			Lerp(ratio, this.yawMaxStart, this.yawMaxEnd),
			Lerp(ratio, this.pitchMinStart, this.pitchMinEnd),
			Lerp(ratio, this.pitchMaxStart, this.pitchMaxEnd)
		);
		return true;
	}
	else
	{
		return false;
	}

    
    
}
LerpRotateAction.prototype.finish = function () {
    this.panel.SetRotateParams(
        this.yawMinEnd,
        this.yawMaxEnd,
        this.pitchMinEnd,
        this.pitchMaxEnd
    );
}

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();
	$.GetContextPanel().RemoveClass('ShowingAlternateStyle');
	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );
	// disabling camera rotation for locked camera
	//$( '#ModelBackground' ).SetRotateParams( 2, 2, 2, 2 );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#ModelBackground' ).RemoveClass( 'Initialize' );
	$( '#ModelBackgroundAlt' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
//	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#TitleContainer' ).RemoveClass( 'Initialize' );
	$( '#Title' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass( 'Initialize' );
	$( '#SnapfireLink' ).RemoveClass( 'Initialize' );
	$( '#AlternateStyleButton' ).RemoveClass( 'Initialize' );
	$( '#DefaultStyleButton' ).RemoveClass( 'Initialize' );
	$( '#SealScene' ).RemoveClass( 'Initialize' );
	

	$('#ModelBackground').SetRotateParams( -0, 0, 0, 0 );
	$('#ModelBackgroundAlt').SetRotateParams( -2, 2, 0, 0 );
	$.Schedule( 1.0, function () { $('#ModelBackgroundAlt').FireEntityInput( 'hero_wraith_king_alt', 'StartGestureOverride', 'ACT_DOTA_IDLE' ); } );
	$.Schedule( 7.2, function () { $('#ModelBackgroundAlt').FireEntityInput( 'hero_wraith_king_alt', 'StartGestureOverride', 'ACT_DOTA_LOADOUT' ); } );
	//$('#ModelBackgroundAlt').FireEntityInput( 'hero_wraith_king_alt', 'StartGestureOverride', 'ACT_DOTA_IDLE' );
	//$.Schedule( 6.07, function () { $('#ModelBackgroundAlt').FireEntityInput( 'hero_wraith_king_alt', 'StartGestureOverride', 'ACT_DOTA_IDLE' ); } );
	//$.Schedule( 2.07, function () { $('#ModelBackground').FireEntityInput( 'hero_wraith_king', 'StartGestureOverride', 'ACT_DOTA_IDLE' ); } );

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
	seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
	seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'PlaySoundEffect', 'wraith_king_arcana_takeover_stinger' ); } ) )
	seq.actions.push( new WaitAction( 0.25 ) );
	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackgroundAlt' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 2.0 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	

	
	seq.actions.push( new WaitAction( 0.0 ) );
//	seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
//	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#TitleContainer' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#Title' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );	
	seq.actions.push( new AddClassAction( $( '#AlternateStyleButton' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#DefaultStyleButton' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#SealScene' ), 'Initialize' ) );
//	seq.actions.push( new WaitAction( 5.0 ) );

		    // enabling camera movement
	seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -2, 2, 0, 0, 5.0));
	seq.actions.push(new LerpRotateAction($('#ModelBackgroundAlt'), 0, 0, 0, 0, -2, 2, 0, 0, 5.0));
	
	RunSingleAction( seq );
}

function alternateStyle()
{
    $.GetContextPanel().AddClass('ShowingAlternateStyle');
	$('#ModelBackground').FireEntityInput('style_switch', 'Stop', '0');
	$('#ModelBackground').FireEntityInput('style_switch', 'Start', '0');
	$('#ModelBackgroundAlt').FireEntityInput('style_switch', 'Stop', '0');
	$('#ModelBackgroundAlt').FireEntityInput('style_switch', 'Start', '0');
	//$.Schedule( 1.34, function () { $('#ModelBackground').FireEntityInput('hero_wraith_king', 'Disable', '0'); } );
	//$.Schedule( 1.34, function () { $('#ModelBackground').FireEntityInput('hero_wraith_king_alt', 'Enable', '0'); } );
}

function originalStyle()
{
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
	$('#ModelBackground').FireEntityInput('style_switch', 'Stop', '0');
	$('#ModelBackground').FireEntityInput('style_switch', 'Start', '0');
	$('#ModelBackgroundAlt').FireEntityInput('style_switch', 'Stop', '0');
	$('#ModelBackgroundAlt').FireEntityInput('style_switch', 'Start', '0');
	//$.Schedule( 1.34, function () { $('#ModelBackground').FireEntityInput('hero_wraith_king', 'Enable', '0'); } );
	//$.Schedule( 1.34, function () { $('#ModelBackground').FireEntityInput('hero_wraith_king_alt', 'Disable', '0'); } );
}

function playArcanaLine()
{
	if ( g_nCurrentVoiceLine == 0)
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_intro_06' );
		g_nCurrentVoiceLine++;
	}
	else if ( g_nCurrentVoiceLine == 1 )
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_level_17' );
		g_nCurrentVoiceLine++;
	}
	else if ( g_nCurrentVoiceLine == 2 )
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_spawn_07' );
		g_nCurrentVoiceLine++;
	}
	else if ( g_nCurrentVoiceLine == 3 )
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_spawn_11' );
		g_nCurrentVoiceLine++;
	}
	else if ( g_nCurrentVoiceLine == 4 )
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_intro_14' );
		g_nCurrentVoiceLine++;
	}
	else if ( g_nCurrentVoiceLine == 5 )
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_graveyard_complete_08' );
		g_nCurrentVoiceLine++;
	}
	else if ( g_nCurrentVoiceLine == 6 )
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_spawn_18' );
		g_nCurrentVoiceLine++;
	}
	else
	{
		$.DispatchEvent( 'PlaySoundEffect', 'skeleton_king_skel_arc_intro_06' );
		g_nCurrentVoiceLine = 1;
	}
	
}