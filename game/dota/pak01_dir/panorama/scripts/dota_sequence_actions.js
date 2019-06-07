// Dota specific sequence actions

// Action to animate an integer dialog variable over some duration of seconds
function LerpRotateAction(panel, yawMinStart, yawMaxStart, pitchMinStart, pitchMaxStart, yawMinEnd, yawMaxEnd, pitchMinEnd, pitchMaxEnd, seconds)
{
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
LerpRotateAction.prototype.start = function ()
{
	this.startTimestamp = Date.now();
	this.endTimestamp = this.startTimestamp + this.seconds * 1000;
}
LerpRotateAction.prototype.update = function ()
{
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
LerpRotateAction.prototype.finish = function ()
{
	this.panel.SetRotateParams(
        this.yawMinEnd,
        this.yawMaxEnd,
        this.pitchMinEnd,
        this.pitchMaxEnd
    );
}