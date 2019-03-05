
var cameraPos = 1;


$.Schedule(0.0, function () {
    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#Model'), function () { $.DispatchEvent('PlaySoundEffect', 'mars_takeover_stinger'); });
});

//IDLE TRIGGER
/*$.Schedule(9.8, function () {
    $('#Model').FireEntityInput('debut_camera', 'SetAnimation', 'debut_camera_shield_bash_idle');
});
*/

//Light Triger
/*$.Schedule(8.9, function () {
    $('#Model').FireEntityInput('light_hero', "TurnOn", '');
    $.Msg("light triggered");
});*/

var showcaseCameraMovement = function (cameraPos)
{
    $.Msg("Camera position = " + cameraPos);
    if (cameraPos === 5) {
        $('#Model').FireEntityInput('debut_camera', 'SetAnimation', 'debut_camera_shield_bash_introframe');
        
    }
    if (cameraPos === 6) {
        $('#DebutInformation').RemoveClass('Initialize');
        
    }
}

var g_Toggle = false;
var TestGlobalLight = function () {
    //var flIntensity = g_Toggle ? 5.0 : 0.5;
    //g_Toggle = !g_Toggle;
    //$( '#Model' ).FireEntityInput( 'light_hero', 'Intensity', flIntensity );

    var strFunction = g_Toggle ? "TurnOn" : "TurnOff";
    g_Toggle = !g_Toggle;
    $('#Model').FireEntityInput('light_hero', strFunction, '');
}


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
    this.panel.SetRotateParams(
        Lerp( ratio, this.yawMinStart, this.yawMinEnd ),
        Lerp( ratio, this.yawMaxStart, this.yawMaxEnd ),
        Lerp( ratio, this.pitchMinStart, this.pitchMinEnd ),
        Lerp( ratio, this.pitchMaxStart, this.pitchMaxEnd )
    );
    return true;
}
LerpRotateAction.prototype.finish = function () {
    this.panel.SetRotateParams(
        this.yawMinEnd,
        this.yawMaxEnd,
        this.pitchMinEnd,
        this.pitchMaxEnd
    );
}

var OnPageSetupSuccess = function ()
{
	// Disabling Fullscreen allows Menu UI to display
	$.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', true);
}

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );
	// disabling camera rotation for locked camera
	//$( '#ModelBackground' ).SetRotateParams( 5, 5, 2, 2 );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#Model' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$('#ItemLore').RemoveClass('Initialize');
	$('#FadeContainer').RemoveClass('Fade');

	seq.actions.push(new AddClassAction($('#BlackBackground'), 'Fade'));
	seq.actions.push(new WaitForClassAction($('#Model'), 'SceneLoaded'));
	seq.actions.push(new AddClassAction($('#FadeContainer'), 'Fade'));
    seq.actions.push( new WaitAction( 8.35 ) );
	seq.actions.push(new AddClassAction($('#Model'), 'Initialize'));
	seq.actions.push(new RunFunctionAction(function () {
	    $('#Model').FireEntityInput('light_hero', "TurnOn", '');
	}))
	seq.actions.push( new WaitAction( 2.5 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction($('#ItemLore'), 'Initialize'));




    // enabling camera movement
    seq.actions.push( new LerpRotateAction( $('#Model'), 0, 0, 0, 0, -2, 2, -2, 2, 5.0 ) );
	//seq.actions.push( new RunFunctionAction( function() 
	//{
	//    $('#Model').SetRotateParams( -2, 2, -2, 2 );
	//} ) );

	RunSingleAction( seq );
}
