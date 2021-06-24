// Sequence actions are objects that you can use to queue up work to happen in a
// sequence over time.  



// Base action, which is something that will tick per-frame for a while until it's done.
function BaseAction() { }

// The start function is called before the action starts executing.
BaseAction.prototype.start = function () { }

// The update function is called once per frame until it returns false signalling that the action is done.
BaseAction.prototype.update = function () { return false; }

// After the update function is complete, the finish function is called
BaseAction.prototype.finish = function () { }


// Action to run a group of other actions in sequence
function RunSequentialActions()
{
	this.actions = [];
}
RunSequentialActions.prototype = new BaseAction();
RunSequentialActions.prototype.start = function ()
{
	this.currentActionIndex = 0;
	this.currentActionStarted = false;
}
RunSequentialActions.prototype.update = function ()
{
	while ( this.currentActionIndex < this.actions.length )
	{
		if ( !this.currentActionStarted )
		{
	        this.actions[this.currentActionIndex].start();
	        this.currentActionStarted = true;
		}

		if ( !this.actions[this.currentActionIndex].update() )
		{
			this.actions[this.currentActionIndex].finish();

			this.currentActionIndex++;
			this.currentActionStarted = false;
		}
		else
		{
			return true;
		}
	}

	return false;
}
RunSequentialActions.prototype.finish = function ()
{
	while ( this.currentActionIndex < this.actions.length )
	{
		if ( !this.currentActionStarted )
		{
			this.actions[this.currentActionIndex].start();
			this.currentActionStarted = true;

			this.actions[this.currentActionIndex].update();
		}

		this.actions[this.currentActionIndex].finish();

		this.currentActionIndex++;
		this.currentActionStarted = false;
	}
}


// Action to run multiple actions all at once. The action is complete once all sub actions are done.
function RunParallelActions()
{
	this.actions = [];
}
RunParallelActions.prototype = new BaseAction();
RunParallelActions.prototype.start = function ()
{
	this.actionsFinished = new Array( this.actions.length );

	for ( var i = 0; i < this.actions.length; ++i )
	{
		this.actionsFinished[i] = false;
		this.actions[i].start();
	}
}
RunParallelActions.prototype.update = function ()
{
	var anyTicking = false;

	for ( var i = 0; i < this.actions.length; ++i )
	{
		if ( !this.actionsFinished[ i ] )
		{
			if ( !this.actions[ i ].update() )
			{
				this.actions[i].finish();
				this.actionsFinished[i] = true;
			}
			else
			{
				anyTicking = true;
			}
		}
	}

	return anyTicking;
}
RunParallelActions.prototype.finish = function ()
{
	for ( var i = 0; i < this.actions.length; ++i )
	{
		if ( !this.actionsFinished[ i ] )
		{
			this.actions[ i ].finish();
			this.actionsFinished[ i ] = true;
		}
	}
}

// Action to rum multiple actions in parallel, but with a slight stagger start between each of them
function RunStaggeredActions( staggerSeconds )
{
	this.actions = [];
	this.staggerSeconds = staggerSeconds;
}
RunStaggeredActions.prototype = new BaseAction();
RunStaggeredActions.prototype.start = function ()
{
	this.par = new RunParallelActions();

	for ( var i = 0; i < this.actions.length; ++i )
	{
		var delay = i * this.staggerSeconds;
		if ( delay > 0 )
		{
			var seq = new RunSequentialActions();
			seq.actions.push( new WaitAction( delay ) );
			seq.actions.push( this.actions[i] );
			this.par.actions.push( seq );
		}
		else
		{
			this.par.actions.push( this.actions[i] );
		}
	}

	this.par.start();
}
RunStaggeredActions.prototype.update = function ()
{
	return this.par.update();
}
RunStaggeredActions.prototype.finish = function ()
{
	this.par.finish();
}


// Runs a set of actions but stops as soon as any of them are finished.  continueOtherActions is a bool
// that determines whether to continue ticking the remaining actions, or whether to just finish them immediately.
function RunUntilSingleActionFinishedAction( continueOtherActions )
{
	this.actions = [];
	this.continueOtherActions = continueOtherActions;
}
RunUntilSingleActionFinishedAction.prototype = new BaseAction();
RunUntilSingleActionFinishedAction.prototype.start = function ()
{
	this.actionsFinished = new Array( this.actions.length );

	for ( var i = 0; i < this.actions.length; ++i )
	{
		this.actionsFinished[i] = false;
		this.actions[i].start();
	}
}
RunUntilSingleActionFinishedAction.prototype.update = function ()
{
	if ( this.actions.length == 0 )
		return false;

	var anyFinished = false;
	for ( var i = 0; i < this.actions.length; ++i )
	{
		if ( !this.actions[i].update() )
		{
			this.actions[i].finish();
			this.actionsFinished[i] = true;
			anyFinished = true;
		}
	}

	return !anyFinished;
}
RunUntilSingleActionFinishedAction.prototype.finish = function ()
{
	if ( this.continueOtherActions )
	{
		// If we want to make sure the rest tick out, then build a new RunParallelActions of all
		// the remaining actions, then have it tick out separately.
		var runParallel = new RunParallelActions();
		for ( var i = 0; i < this.actions.length; ++i )
		{
			if ( !this.actionsFinished[i] )
			{
				runParallel.actions.push( this.actions[i] );
			}
		}

		if ( runParallel.actions.length > 0 )
		{
			UpdateSingleActionUntilFinished( runParallel );
		}
	}
	else
	{
		// Just finish each action immediately
		for ( var i = 0; i < this.actions.length; ++i )
		{
			if ( !this.actionsFinished[i] )
			{
				this.actions[i].finish();
			}
		}
	}
}


// Action that simply runs a passed in function. You may include extra arguments and they will be passed to the called function.
function RunFunctionAction( f )
{
	this.f = f;
	this.argsArray = [];

	for ( var i = 1; i < arguments.length; ++i )
	{
		this.argsArray.push( arguments[i] );
	}
}
RunFunctionAction.prototype = new BaseAction();
RunFunctionAction.prototype.update = function ()
{
	this.f.apply( null, this.argsArray );
	return false;
}


function WaitForConditionAction( f )
{
	this.f = f;
	this.argsArray = [];
	for ( var i  = 1; i < arguments.length; ++i )
	{
		this.argsArray.push( arguments[i] );
	}
}
WaitForConditionAction.prototype = new BaseAction();
WaitForConditionAction.prototype.update = function()
{
	return !this.f.apply( null, this.argsArray );	
}

// Action to wait for some amount of seconds before resuming
function WaitAction( seconds )
{
	this.seconds = seconds;
}
WaitAction.prototype = new BaseAction();
WaitAction.prototype.start = function ()
{
	this.endTimestamp = Game.Time() + this.seconds;
}
WaitAction.prototype.update = function ()
{
	return Game.Time() < this.endTimestamp;
}

// Action to wait a single frame
function WaitOneFrameAction()
{
}
WaitOneFrameAction.prototype = new BaseAction();
WaitOneFrameAction.prototype.start = function ()
{
	this.updated = false;
}
WaitOneFrameAction.prototype.update = function ()
{
	if ( this.updated )
		return false;

	this.updated = true;
	return true;
}

// Action that waits for a specific event type to be fired on the given panel.
function WaitForEventAction( panel, eventName )
{
	this.panel = panel;
	this.eventName = eventName;
}
WaitForEventAction.prototype = new BaseAction();
WaitForEventAction.prototype.start = function ()
{
	this.receivedEvent = false;
	var action = this;
	$.RegisterEventHandler( this.eventName, this.panel, function ()
	{
		action.receivedEvent = true;
	} );
}
WaitForEventAction.prototype.update = function ()
{
	return !this.receivedEvent;
}


// Run an action until it's complete, or until it hits a timeout. continueAfterTimeout is a bool
// determining whether to continue ticking the action after it has timed out
function ActionWithTimeout( action, timeoutDuration, continueAfterTimeout )
{
	this.action = action;
	this.timeoutDuration = timeoutDuration;
	this.continueAfterTimeout = continueAfterTimeout;
}
ActionWithTimeout.prototype = new BaseAction();
ActionWithTimeout.prototype.start = function ()
{
	this.allAction = new RunUntilSingleActionFinishedAction( this.continueAfterTimeout );
	this.allAction.actions.push( this.action );
	this.allAction.actions.push( new WaitAction( this.timeoutDuration ) );
	this.allAction.start();
}
ActionWithTimeout.prototype.update = function ()
{
	return this.allAction.update();
}
ActionWithTimeout.prototype.finish = function ()
{
	this.allAction.finish();
}


// Action to print a debug message
function PrintAction( msg )
{
	this.msg = msg;
}
PrintAction.prototype = new BaseAction();
PrintAction.prototype.update = function ()
{
	$.Msg( this.msg );
	return false;
}


// Action to add a class to a panel
function AddClassAction( panel, panelClass )
{
	this.panel = panel;
	this.panelClass = panelClass;
}
AddClassAction.prototype = new BaseAction();
AddClassAction.prototype.update = function ()
{
	if ( this != null && this.panel != null )
		this.panel.AddClass( this.panelClass );
	return false;
}

// Action to remove a class to a panel
function RemoveClassAction( panel, panelClass )
{
	this.panel = panel;
	this.panelClass = panelClass;
}
RemoveClassAction.prototype = new BaseAction();
RemoveClassAction.prototype.update = function ()
{
	this.panel.RemoveClass( this.panelClass );
	return false;
}

// Switch a class on a panel
function SwitchClassAction( panel, panelSlot, panelClass )
{
	this.panel = panel;
	this.panelSlot = panelSlot;
	this.panelClass = panelClass;
}
SwitchClassAction.prototype = new BaseAction();
SwitchClassAction.prototype.update = function ()
{
	this.panel.SwitchClass( this.panelSlot, this.panelClass );
	return false;
}


// Action to trigger a class on a panel
function TriggerClassAction( panel, panelClass )
{
	this.panel = panel;
	this.panelClass = panelClass;
}
TriggerClassAction.prototype = new BaseAction();
TriggerClassAction.prototype.update = function ()
{
	this.panel.TriggerClass( this.panelClass );
	return false;
}


// Action to wait for a class to appear on a panel
function WaitForClassAction( panel, panelClass )
{
	this.panel = panel;
	this.panelClass = panelClass;
}
WaitForClassAction.prototype = new BaseAction();
WaitForClassAction.prototype.update = function ()
{
	return !this || !this.panel || !this.panel.BHasClass( this.panelClass );
}


// Action to set an integer dialog variable
function SetDialogVariableIntAction( panel, dialogVariable, value )
{
	this.panel = panel;
	this.dialogVariable = dialogVariable;
	this.value = value;
}
SetDialogVariableIntAction.prototype = new BaseAction();
SetDialogVariableIntAction.prototype.update = function ()
{
	this.panel.SetDialogVariableInt( this.dialogVariable, this.value );
	return false;
}


// Action to animate an integer dialog variable over some duration of seconds
function AnimateDialogVariableIntAction( panel, dialogVariable, start, end, seconds )
{
	this.panel = panel;
	this.dialogVariable = dialogVariable;
	this.startValue = start;
	this.endValue = end;
	this.seconds = seconds;
}
AnimateDialogVariableIntAction.prototype = new BaseAction();
AnimateDialogVariableIntAction.prototype.start = function ()
{
	this.startTimestamp = Game.Time();
	this.endTimestamp = this.startTimestamp + this.seconds;
}
AnimateDialogVariableIntAction.prototype.update = function ()
{
	var now = Game.Time();
	if ( now >= this.endTimestamp )
		return false;

	var ratio = ( now - this.startTimestamp ) / ( this.endTimestamp - this.startTimestamp );

	this.panel.SetDialogVariableInt( this.dialogVariable, Math.floor(this.startValue + ( this.endValue - this.startValue ) * ratio ));
	return true;
}
AnimateDialogVariableIntAction.prototype.finish = function ()
{
	this.panel.SetDialogVariableInt( this.dialogVariable, this.endValue );
}


// Action to set a string dialog variable
function SetDialogVariableStringAction( panel, dialogVariable, value )
{
	this.panel = panel;
	this.dialogVariable = dialogVariable;
	this.value = value;
}
SetDialogVariableStringAction.prototype = new BaseAction();
SetDialogVariableStringAction.prototype.update = function ()
{
	this.panel.SetDialogVariable( this.dialogVariable, this.value );
	return false;
}


// Action to set a progress bar's value
function SetProgressBarValueAction( progressBar, value )
{
	this.progressBar = progressBar;
	this.value = value;
}
SetProgressBarValueAction.prototype = new BaseAction();
SetProgressBarValueAction.prototype.update = function ()
{
	this.progressBar.value = this.value;
	return false;
}


// Action to animate a progress bar
function AnimateProgressBarAction( progressBar, startValue, endValue, seconds )
{
	this.progressBar = progressBar;
	this.startValue = startValue;
	this.endValue = endValue;
	this.seconds = seconds;
}
AnimateProgressBarAction.prototype = new BaseAction();
AnimateProgressBarAction.prototype.start = function ()
{
	this.startTimestamp = Game.Time();
	this.endTimestamp = this.startTimestamp + this.seconds;
}
AnimateProgressBarAction.prototype.update = function ()
{
	var now = Game.Time();
	if ( now >= this.endTimestamp )
		return false;

	var ratio = ( now - this.startTimestamp ) / ( this.endTimestamp - this.startTimestamp );
	this.progressBar.value = this.startValue + ( this.endValue - this.startValue ) * ratio;
	return true;
}
AnimateProgressBarAction.prototype.finish = function ()
{
	this.progressBar.value = this.endValue;
}


// Action to animate a progress bar	with middle
function AnimateProgressBarWithMiddleAction( progressBar, startValue, endValue, seconds )
{
	this.progressBar = progressBar;
	this.startValue = startValue;
	this.endValue = endValue;
	this.seconds = seconds;
}
AnimateProgressBarWithMiddleAction.prototype = new BaseAction();
AnimateProgressBarWithMiddleAction.prototype.start = function ()
{
	this.startTimestamp = Game.Time();
	this.endTimestamp = this.startTimestamp + this.seconds;
}
AnimateProgressBarWithMiddleAction.prototype.update = function ()
{
	var now = Game.Time();
	if ( now >= this.endTimestamp )
		return false;

	var ratio = ( now - this.startTimestamp ) / ( this.endTimestamp - this.startTimestamp );
	this.progressBar.uppervalue = this.startValue + ( this.endValue - this.startValue ) * ratio;
	return true;
}
AnimateProgressBarWithMiddleAction.prototype.finish = function ()
{
	this.progressBar.uppervalue = this.endValue;
}


// Action to play a sound effect
function PlaySoundEffect( soundName )
{
	$.DispatchEvent( 'PlaySoundEffect', soundName );
}
function PlaySoundEffectAction( soundName )
{
	this.soundName = soundName;
}
PlaySoundEffectAction.prototype = new BaseAction();
PlaySoundEffectAction.prototype.update = function ()
{
	PlaySoundEffect( this.soundName );
	return false;
}


// ----------------------------------------------------------------------------
//   PlaySoundAction
// ----------------------------------------------------------------------------

function PlaySoundAction( soundName )
{
	this.soundName = soundName;
}
PlaySoundAction.prototype = new BaseAction();

PlaySoundAction.prototype.update = function ()
{
	PlayUISoundScript( this.soundName );
	return false;
}

// ----------------------------------------------------------------------------
//   PlaySoundForDurationAction
// ----------------------------------------------------------------------------

function PlaySoundForDurationAction( soundName, duration )
{
	this.soundName = soundName;
	this.duration = duration;
}
PlaySoundForDurationAction.prototype = new BaseAction();

PlaySoundForDurationAction.prototype.start = function ()
{
	this.soundEventGuid = PlayUISoundScript( this.soundName );

	this.waitAction = new WaitAction( this.duration );
	this.waitAction.start();
}
PlaySoundForDurationAction.prototype.update = function ()
{
	return this.waitAction.update();
}
PlaySoundForDurationAction.prototype.finish = function ()
{
	StopUISoundScript( this.soundEventGuid );
	this.waitAction.finish();
}

// ----------------------------------------------------------------------------
//   LerpAction
//
//   Base class that you can override an applyProgress for to do a simple Lerp
//   over X seconds.
// ----------------------------------------------------------------------------

function LerpAction(seconds)
{
	this.seconds = seconds;
}
LerpAction.prototype = new BaseAction();
LerpAction.prototype.start = function ()
{
	this.startTimestamp = Game.Time();
	this.endTimestamp = this.startTimestamp + this.seconds;
}
LerpAction.prototype.update = function ()
{
	var now = Game.Time();
	if (now >= this.endTimestamp)
		return false;

	var ratio = (now - this.startTimestamp) / (this.endTimestamp - this.startTimestamp);
	this.applyProgress( ratio );
	return true;
}
LerpAction.prototype.finish = function ()
{
	this.applyProgress( 1.0 );
}
LerpAction.prototype.applyProgress = function ( progress )
{
	// Override this method to apply your progress
}

// ----------------------------------------------------------------------------

// Helper function to asynchronously tick a single action until it's finished, then call finish on it.
function UpdateSingleActionUntilFinished( action )
{
	var callback = function ()
	{
		if ( !action.update() )
		{
			action.finish();
		}
		else
		{
			$.Schedule( 0.0, callback );
		}
	};
	callback();
}

// Call RunSingleAction to start a single action and continue ticking it until it's done
function RunSingleAction( action )
{
	action.start();
	UpdateSingleActionUntilFinished( action );
}
