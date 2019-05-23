var ToggleInfo = function ()
{
	$('#InformationBody').ToggleClass('Initialize');
	$('#InformationBodyBackground').ToggleClass('Initialize');
}

function crackMountain()
{
	$('#ModelBackground').FireEntityInput('mountain_crack', 'Start', '0');
}

function crackMountainReset()
{
	$('#ModelBackground').FireEntityInput('mountain_crack', 'Stop', '0');
}

function alternateStyle()
{
	$.GetContextPanel().AddClass('ShowingAlternateStyle');
	$('#ModelBackground').FireEntityInput('hero_shaker', 'Disable', '0');
	$('#ModelBackground').FireEntityInput('hero_shaker_alt', 'Enable', '0');
	$('#ModelBackground').FireEntityInput('shaker_style_0', 'Stop', '0');
	$('#ModelBackground').FireEntityInput('shaker_style_1', 'Start', '0');
	$('#ModelBackground').FireEntityInput('fake_light', "Stop", '0');
	$('#ModelBackground').FireEntityInput('fake_light_alt', "Start", '0');
	$('#ModelBackground').FireEntityInput('ground_a', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_b', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_c', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_d', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_e', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_a', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_b', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_c', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_d', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_e', "TurnOn", '0');
}

function originalStyle()
{
	$.GetContextPanel().RemoveClass('ShowingAlternateStyle');
	$('#ModelBackground').FireEntityInput('hero_shaker', 'Enable', '0');
	$('#ModelBackground').FireEntityInput('hero_shaker_alt', 'Disable', '0');
	$('#ModelBackground').FireEntityInput('shaker_style_0', 'Start', '0');
	$('#ModelBackground').FireEntityInput('shaker_style_1', 'Stop', '0');
	$('#ModelBackground').FireEntityInput('fake_light', "Start", '0');
	$('#ModelBackground').FireEntityInput('fake_light_alt', "Stop", '0');
	$('#ModelBackground').FireEntityInput('ground_a', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_b', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_c', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_d', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_e', "TurnOn", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_a', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_b', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_c', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_d', "TurnOff", '0');
	$('#ModelBackground').FireEntityInput('ground_alt_e', "TurnOff", '0');
}

function panelHide()
{
	$('#ControlButtonsContainer').AddClass('Hide')
}

var OnPageSetupSuccess = function () {
    // Disabling Fullscreen allows Menu UI to display
    $.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', true);
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
        Lerp(ratio, this.yawMinStart, this.yawMinEnd),
        Lerp(ratio, this.yawMaxStart, this.yawMaxEnd),
        Lerp(ratio, this.pitchMinStart, this.pitchMinEnd),
        Lerp(ratio, this.pitchMaxStart, this.pitchMaxEnd)
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

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );
	// disabling camera rotation for locked camera
	$( '#ModelBackground' ).SetRotateParams( 0, 0, 0, 0 );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#ModelBackground' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass('Initialize');
	$( '#CloseButton' ).RemoveClass('Initialize');
	$( '#AlternateStyleButton' ).RemoveClass('Initialize');
	$( '#DefaultStyleButton' ).RemoveClass('Initialize');

	// Disabling Fullscreen allows Menu UI to display
	//$.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true );

	seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded') );
	seq.actions.push( new RunFunctionAction( function () { $.DispatchEvent('PlaySoundEffect', 'earthshaker_takeover_stinger'); }));
	seq.actions.push( new RunFunctionAction( function () {
	    $('#ModelBackground').FireEntityInput('ground_alt_a', "TurnOff", '0');
	    $('#ModelBackground').FireEntityInput('ground_alt_b', "TurnOff", '0');
	    $('#ModelBackground').FireEntityInput('ground_alt_c', "TurnOff", '0');
	    $('#ModelBackground').FireEntityInput('ground_alt_d', "TurnOff", '0');
	    $('#ModelBackground').FireEntityInput('ground_alt_e', "TurnOff", '0');
	}));
	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	// Waiting X seconds before flash happens
	seq.actions.push( new WaitAction( 3.05 ) );
	seq.actions.push( new RunFunctionAction( function () {
	    $('#ModelBackground').FireEntityInput('light_hero', "LightScale", '3');
	    $('#ModelBackground').FireEntityInput('light_crater', "Intensity", '3');
	    $('#ModelBackground').FireEntityInput('fake_light', "Start", '0');
	}))

	seq.actions.push( new WaitAction( 1.1 ) );
	seq.actions.push( new RunFunctionAction( function () {
	    $('#ModelBackground').FireEntityInput('mountain_crack', "Start", '0');
	}))
	seq.actions.push( new WaitAction( 1.5 ) );

	seq.actions.push(new AddClassAction($('#DebutInformation'), 'Initialize'));
	seq.actions.push(new AddClassAction($('#InformationBodyBackground'), 'Initialize'));
	seq.actions.push(new WaitAction(0.4));
	seq.actions.push(new AddClassAction($('#InformationBody'), 'Initialize'));
	seq.actions.push(new WaitAction(0.1));
	seq.actions.push(new AddClassAction($('#ItemName'), 'Initialize'));
	seq.actions.push(new AddClassAction($('#TitleFX'), 'Initialize'));
	seq.actions.push(new AddClassAction($('#AlternateStyleButton'), 'Initialize'));
	seq.actions.push(new AddClassAction($('#DefaultStyleButton'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#CloseButton'), 'Initialize'));
	seq.actions.push(new WaitAction(0.3));
	seq.actions.push(new AddClassAction($('#ItemLore'), 'Initialize'));

    // enabling camera movement
	seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -2, 2, -2, 2, 5.0));

	RunSingleAction(seq);
}
