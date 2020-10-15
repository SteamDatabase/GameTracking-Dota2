
// Keep in sync with EHeroBadgeXPType
const HERO_BADGE_XP_TYPE_MATCH_FINISHED = 0;
const HERO_BADGE_XP_TYPE_MATCH_WON = 1;
const HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED = 2;

// Keep in sync with EHeroBadgeLevelReward
const HERO_BADGE_LEVEL_REWARD_TIER = 0;
const HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL = 1;
const HERO_BADGE_LEVEL_REWARD_CURRENCY = 2;

// Keep in sync with the version in dota_plus.h
const k_unMaxHeroRewardLevel = 25;

// ----------------------------------------------------------------------------
//   Screen Handling functions
// ----------------------------------------------------------------------------

function CreateProgressScreen( panelID )
{
	var screenPanel = $.CreatePanel( 'Panel', $( '#ProgressScreens' ), panelID );
	screenPanel.AddClass( 'ProgressScreen' );
	return screenPanel;
}

function ShowProgressScreen( screenPanel )
{
	var screensContainer = $( '#ProgressScreens' );
	for ( var i = 0; i < screensContainer.GetChildCount() ; ++i )
	{
		var otherScreenPanel = screensContainer.GetChild( i );
		otherScreenPanel.SetHasClass( 'ShowScreen', otherScreenPanel == screenPanel );
	}
}

function StartNewScreen( panelID )
{
	var screenPanel = CreateProgressScreen( panelID );
	ShowProgressScreen( screenPanel );
	return screenPanel;
}


function GetScreenLinksContainer()
{
	// This is sorta hacky, but we need to reach into the parent's layout file to find our button container.
	return $.GetContextPanel().GetParent().FindPanelInLayoutFile( 'ProgressScreenButtons' );
}

/* Called from C++ code */
function ResetScreens()
{
	$( '#ProgressScreens' ).RemoveAndDeleteChildren();
	GetScreenLinksContainer().RemoveAndDeleteChildren();
}

function AddScreenLink( screenPanel, linkClass, tooltipText, activateFunction )
{
	var link = $.CreatePanel( 'Button', GetScreenLinksContainer(), '' );
	link.AddClass( 'ProgressScreenButton' );
	link.AddClass( linkClass );

	link.SetPanelEvent( 'onactivate', function ()
	{
		$.DispatchEvent( 'DOTAPostGameProgressShowSummary', screenPanel );
		ShowProgressScreen( screenPanel );
		if ( activateFunction )
		{
			activateFunction();
		}
	} );

	link.SetPanelEvent( 'onmouseover', function () { $.DispatchEvent( 'UIShowTextTooltip', link, tooltipText ); } );
	link.SetPanelEvent( 'onmouseout', function () { $.DispatchEvent( 'UIHideTextTooltip', link ); } );

	return link;
}

function AddScreenLinkAction( screenPanel, linkClass, tooltipText, activateFunction )
{
	RunFunctionAction.call( this, function () { AddScreenLink( screenPanel, linkClass, tooltipText, activateFunction ); } );
}
AddScreenLinkAction.prototype = new RunFunctionAction();


// ----------------------------------------------------------------------------
//   Skip Ahead Functions
// ----------------------------------------------------------------------------

var g_bSkipAheadActions = false;

function IsSkippingAhead()
{
	return g_bSkipAheadActions;
}

function SetSkippingAhead( bSkipAhead )
{
	if ( g_bSkipAheadActions == bSkipAhead )
		return;

	if ( bSkipAhead )
	{
		$.DispatchEvent( "PostGameProgressSkippingAhead" );
	}
	$.GetContextPanel().SetHasClass( 'SkippingAhead', bSkipAhead );
	g_bSkipAheadActions = bSkipAhead;

	if ( bSkipAhead )
	{
		PlayUISoundScript( "ui_generic_button_click" );
	}
}
function StopSkippingAhead() { SetSkippingAhead( false ); }
function StartSkippingAhead() { SetSkippingAhead( true ); }

// ----------------------------------------------------------------------------
//   StopSkippingAheadAction
// 
//   Define a point at which we stop skipping (usually the end of a screen)
// ----------------------------------------------------------------------------

// Use a StopSkippingAheadAction to define a stopping point
function StopSkippingAheadAction()
{
}
StopSkippingAheadAction.prototype = new BaseAction();
StopSkippingAheadAction.prototype.update = function ()
{
	StopSkippingAhead();
	return false;
}


// ----------------------------------------------------------------------------
//   SkippableAction
// 
//   Wrap a SkippableAction around any other action to have it skip ahead
//   whenever we're supposed to skip ahead. SkippableAction guarantees that the
//   inner action will at least have start/update/finish called on it.
// ----------------------------------------------------------------------------
function SkippableAction( actionToMaybeSkip )
{
	this.innerAction = actionToMaybeSkip;
}
SkippableAction.prototype = new BaseAction();

SkippableAction.prototype.start = function ()
{
	this.innerAction.start();
}
SkippableAction.prototype.update = function ()
{
	return this.innerAction.update() && !IsSkippingAhead();
}
SkippableAction.prototype.finish = function ()
{
	this.innerAction.finish();
}



// Action to rum multiple actions in parallel, but with a slight stagger start between each of them
function RunSkippableStaggeredActions( staggerSeconds )
{
	this.actions = [];
	this.staggerSeconds = staggerSeconds;
}
RunSkippableStaggeredActions.prototype = new BaseAction();
RunSkippableStaggeredActions.prototype.start = function ()
{
	this.par = new RunParallelActions();

	for ( var i = 0; i < this.actions.length; ++i )
	{
		var delay = i * this.staggerSeconds;
		if ( delay > 0 )
		{
			var seq = new RunSequentialActions();
			seq.actions.push( new SkippableAction( new WaitAction( delay ) ) );
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
RunSkippableStaggeredActions.prototype.update = function ()
{
	return this.par.update();
}
RunSkippableStaggeredActions.prototype.finish = function ()
{
	this.par.finish();
}


// ----------------------------------------------------------------------------
//   OptionalSkippableAction
// 
//   Wrap a OptionalSkippableAction around any other action to have it skip it
//   if requested. OptionalSkippableAction will skip the inner action entirely
//   if skipping is currently enabled. However, if it starts the inner action
//   at all, then it will guarantee at least a call to start/update/finish.
// ----------------------------------------------------------------------------
function OptionalSkippableAction( actionToMaybeSkip )
{
	this.innerAction = actionToMaybeSkip;
}
OptionalSkippableAction.prototype = new BaseAction();

OptionalSkippableAction.prototype.start = function ()
{
	this.innerActionStarted = false;

	if ( !IsSkippingAhead() )
	{
		this.innerAction.start();
		this.innerActionStarted = true;
	}
}
OptionalSkippableAction.prototype.update = function ()
{
	if ( this.innerActionStarted )
		return this.innerAction.update() && !IsSkippingAhead();

	if ( IsSkippingAhead() )
		return false;

	this.innerAction.start();
	this.innerActionStarted = true;

	return this.innerAction.update();
}
OptionalSkippableAction.prototype.finish = function ()
{
	if ( this.innerActionStarted )
	{
		this.innerAction.finish();
	}
}
