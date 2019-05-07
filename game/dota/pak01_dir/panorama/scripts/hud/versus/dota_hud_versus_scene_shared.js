
// For debugging, allow turning off the fade out
var g_bFadeOutEnabled = true;
function IsFadeOutEnabled()
{
	return g_bFadeOutEnabled;
}
function SetFadeOutEnabled( bEnabled )
{
	g_bFadeOutEnabled = bEnabled;

	var toggleButton = $( '#ToggleFadeOut' );
	if ( toggleButton )
	{
		toggleButton.SetSelected( bEnabled );
	}
}
function ToggleFadeOutEnabled()
{
	SetFadeOutEnabled( !IsFadeOutEnabled() );
}

// Action to fire entity input on a scene panel
function FireEntityInputAction( scenePanel, entityName, entityInput, entityInputValue )
{
	this.scenePanel = scenePanel;
	this.entityName = entityName;
	this.entityInput = entityInput;
	this.entityInputValue = entityInputValue;
}
FireEntityInputAction.prototype = new BaseAction();
FireEntityInputAction.prototype.update = function ()
{
	this.scenePanel.FireEntityInput( this.entityName, this.entityInput, this.entityInputValue );
	return false;
}


// Action to animate the playback rate of an entity on a scene panel
function AnimateEntityInputAction( scenePanel, entityName, entityInput, startValue, endValue, seconds )
{
	this.scenePanel = scenePanel;
	this.entityName = entityName;
	this.entityInput = entityInput;
	this.startValue = startValue;
	this.endValue = endValue;
	this.seconds = seconds;
}

AnimateEntityInputAction.prototype = new BaseAction();
AnimateEntityInputAction.prototype.start = function ()
{
	this.startTimestamp = Date.now();
	this.endTimestamp = this.startTimestamp + this.seconds * 1000;
}
AnimateEntityInputAction.prototype.update = function ()
{
	var now = Date.now();
	if (now >= this.endTimestamp)
		return false;

	this.scenePanel.FireEntityInput( this.entityName, this.entityInput, RemapValClamped( now, this.startTimestamp, this.endTimestamp, this.startValue, this.endValue ) );
	return true;
}
AnimateEntityInputAction.prototype.finish = function ()
{
	this.scenePanel.FireEntityInput( this.entityName, this.entityInput, this.endValue );
}