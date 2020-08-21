// Dota specific sequence actions

// ----------------------------------------------------------------------------
//  LerpRotateAction
// 
//  Action to lerp the rotation parameters of a Scene Panel
// ----------------------------------------------------------------------------
function LerpRotateAction(panel, yawMinStart, yawMaxStart, pitchMinStart, pitchMaxStart, yawMinEnd, yawMaxEnd, pitchMinEnd, pitchMaxEnd, seconds)
{
	LerpAction.call( this, seconds );

	this.panel = panel;

	this.yawMinStart = yawMinStart;
	this.yawMaxStart = yawMaxStart;
	this.pitchMinStart = pitchMinStart;
	this.pitchMaxStart = pitchMaxStart;
	this.yawMinEnd = yawMinEnd;
	this.yawMaxEnd = yawMaxEnd;
	this.pitchMinEnd = pitchMinEnd;
	this.pitchMaxEnd = pitchMaxEnd;
}
LerpRotateAction.prototype = new LerpAction();
LerpRotateAction.prototype.applyProgress = function ( progress )
{
	this.panel.SetRotateParams(
        Lerp(progress, this.yawMinStart, this.yawMinEnd),
        Lerp(progress, this.yawMaxStart, this.yawMaxEnd),
        Lerp(progress, this.pitchMinStart, this.pitchMinEnd),
        Lerp(progress, this.pitchMaxStart, this.pitchMaxEnd)
    );
}


// ----------------------------------------------------------------------------
//  LerpDepthOfFieldAction
// 
//  Action to lerp the Depth of Field parameters of a Scene Panel
// ----------------------------------------------------------------------------
function LerpDepthOfFieldAction(panel, cameraName, nearBlurryDistanceStart, nearCrispDistanceStart, farCrispDistanceStart, farBlurryDistanceStart, nearBlurryDistanceEnd, nearCrispDistanceEnd, farCrispDistanceEnd, farBlurryDistanceEnd, seconds)
{
	LerpAction.call( this, seconds );

	this.panel = panel;
	this.cameraName = cameraName;

	this.nearBlurryDistanceStart = nearBlurryDistanceStart;
	this.nearCrispDistanceStart = nearCrispDistanceStart;
	this.farCrispDistanceStart = farCrispDistanceStart;
	this.farBlurryDistanceStart = farBlurryDistanceStart;
	this.nearBlurryDistanceEnd = nearBlurryDistanceEnd;
	this.nearCrispDistanceEnd = nearCrispDistanceEnd;
	this.farCrispDistanceEnd = farCrispDistanceEnd;
	this.farBlurryDistanceEnd = farBlurryDistanceEnd;
}
LerpDepthOfFieldAction.prototype = new LerpAction();
LerpDepthOfFieldAction.prototype.applyProgress = function ( progress )
{
	this.panel.FireEntityInput( this.cameraName, 'SetDOFNearBlurry', Lerp( progress, this.nearBlurryDistanceStart, this.nearBlurryDistanceEnd ) );
	this.panel.FireEntityInput( this.cameraName, 'SetDOFNearCrisp', Lerp( progress, this.nearCrispDistanceStart, this.nearCrispDistanceEnd ) );
	this.panel.FireEntityInput( this.cameraName, 'SetDOFFarCrisp', Lerp( progress, this.farCrispDistanceStart, this.farCrispDistanceEnd ) );
	this.panel.FireEntityInput( this.cameraName, 'SetDOFFarBlurry', Lerp( progress, this.farBlurryDistanceStart, this.farBlurryDistanceEnd ) );
}