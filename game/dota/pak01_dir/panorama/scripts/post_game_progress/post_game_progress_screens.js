

// ----------------------------------------------------------------------------
//   Battle pass level progress bar
// ----------------------------------------------------------------------------
function AnimateBattlePassLevelsAction( panel, eventId, bpPointsStart, bpPointsPerLevel, bpPointsAdd )
{
    this.panel = panel;
    this.eventId = eventId;
    this.bpPointsStart = bpPointsStart;
    this.bpPointsPerLevel = bpPointsPerLevel;
    this.bpPointsAdd = bpPointsAdd;
    this.seq = new RunSequentialActions();

    var battlePointsStart = this.bpPointsStart;
    var battleLevelStart = Math.floor( battlePointsStart / this.bpPointsPerLevel );
    var battlePointsAtLevelStart = battleLevelStart * this.bpPointsPerLevel;
    var bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
    var bpLevelNext = this.bpPointsPerLevel;

    panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
    panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
    panel.FindChildInLayoutFile( 'BattlePassLevelShield' ).SetEventLevel( this.eventId, battleLevelStart );

    var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
    progressBar.max = bpLevelNext;
    progressBar.lowervalue = bpLevelStart;
    progressBar.uppervalue = bpLevelStart;

    var bpEarned = 0;
    var bpLevel = bpLevelStart;
    var battleLevel = battleLevelStart;

    var bpRemaining = this.bpPointsAdd;
    var bpEarnedOnRow = 0;

    while ( bpRemaining > 0 )
    {
        var bpToAnimate = 0;
        var bpToNextLevel = 0;
        bpToNextLevel = bpLevelNext - bpLevel;
        bpToAnimate = Math.min( bpRemaining, bpToNextLevel );

        if ( bpToAnimate > 0 )
        {
            this.seq.actions.push( new SkippableAction( new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) ) );

            bpEarned += bpToAnimate;
            bpLevel += bpToAnimate;
            bpEarnedOnRow += bpToAnimate;
            bpRemaining -= bpToAnimate;
        }

        bpToNextLevel = bpLevelNext - bpLevel;

        if ( bpToNextLevel != 0 )
            continue;

        battleLevel = battleLevel + 1;
        bpLevel = 0;

        this.seq.actions.push( new AddClassAction( panel, 'LeveledUpStart' ) );

        ( function ( me, battleLevelInternal ) {
            me.seq.actions.push( new RunFunctionAction( function () {
                var levelShield = panel.FindChildInLayoutFile( 'BattlePassLevelShield' );
                levelShield.AddClass( 'LeveledUp' );
                levelShield.SetEventLevel( me.eventId, battleLevelInternal );
            } ) );
        } )( this, battleLevel );

        this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
        this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

        ( function ( me, battleLevelInternal ) {
            me.seq.actions.push( new RunFunctionAction( function () {
                var levelShield = panel.FindChildInLayoutFile( 'BattlePassLevelShield' );
                levelShield.RemoveClass( 'LeveledUp' );
            } ) );
        } )( this, battleLevel );
        this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

        ( function ( me, bpLevelInternal, bpLevelNextInternal ) {
            me.seq.actions.push( new RunFunctionAction( function () {
                progressBar.lowervalue = 0;
                progressBar.uppervalue = 0;
                panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
                panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
                panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
                panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
            } ) );
        } )( this, bpLevel, bpLevelNext );
    }
}

AnimateBattlePassLevelsAction.prototype = new BaseAction();
AnimateBattlePassLevelsAction.prototype.start = function () {
    return this.seq.start();
}
AnimateBattlePassLevelsAction.prototype.update = function () {
    return this.seq.update();
}
AnimateBattlePassLevelsAction.prototype.finish = function () {
    this.seq.finish();
}

// ----------------------------------------------------------------------------
//
// Cavern Crawl Screen
//
// ----------------------------------------------------------------------------

function AnimateCavernCrawlScreenAction( data )
{
	this.data = data;
}

AnimateCavernCrawlScreenAction.prototype = new BaseAction();

AnimateCavernCrawlScreenAction.prototype.start = function ()
{
    var heroID = this.data.hero_id;
    var eventID = this.data.cavern_crawl_progress.event_id;
    var mapVariant = this.data.cavern_crawl_progress.map_variant;
	var turboMode = this.data.cavern_crawl_progress.turbo_mode;
	var mapProgress = this.data.cavern_crawl_progress.map_progress;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'CavernCrawlProgressScreen' );
	panel.BLoadLayoutSnippet( "CavernCrawlProgress" );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
    this.eventHandler = null;

    ( function (me) 
    {
        me.seq.actions.push( new RunFunctionAction( function ()
        {
            var hHandler = (function (me2)
            {
                return function ()
                {
                    if ( !me2.disabled_update )
                    {
                        me2.disabled_update = true;
                        me2.cavern_panel.DisableUpdateDisplay(true);
                    }
                };
            }(me));

            me.eventHandler = $.RegisterForUnhandledEvent("PostGameProgressSkippingAhead", hHandler);
        }));
    })(this);

	this.seq.actions.push( new AddScreenLinkAction( panel, 'CavernsProgress', '#DOTACavernCrawl_Title_TI2020' ) );

	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

    var cavernCrawlPanel = panel.FindChildInLayoutFile('CavernCrawl');

	this.seq.actions.push( new AddClassAction( panel, 'ShowCavernCrawlProgress' ) );
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		cavernCrawlPanel.ClearMapResults();
		if ( mapProgress )
		{
			for ( var i = 0; i < mapProgress.length; ++i )
			{
				var result = mapProgress[i]
				cavernCrawlPanel.AddMapResult( result.path_id_completed, result.room_id_claimed );
			}
		}
        cavernCrawlPanel.ShowPostGameProgress( eventID, 0, mapVariant, heroID, turboMode );
	} ) );
	this.seq.actions.push( new WaitForEventAction( cavernCrawlPanel, 'DOTACavernCrawlPostGameProgressComplete' ) );
	this.seq.actions.push( new StopSkippingAheadAction() );

	this.seq.start();

	this.cavern_panel = panel.FindChildInLayoutFile( "CavernCrawl" );
}

AnimateCavernCrawlScreenAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateCavernCrawlScreenAction.prototype.finish = function ()
{
    if ( this.eventHandler != null )
    {
        $.UnregisterForUnhandledEvent("PostGameProgressSkippingAhead", this.eventHandler);
        this.eventHandler = null;
    }

	if ( this.disabled_update )
	{
        this.cavern_panel.DisableUpdateDisplay(false);
        this.disabled_update = false;
	}
	this.seq.finish();
}

// ----------------------------------------------------------------------------
//
// Battle Points
//
// ----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Animates battle points within a single level
//-----------------------------------------------------------------------------
function GetBPIncreaseAnimationDuration( bpAmount )
{
	return RemapValClamped( bpAmount, 0, 500, 0.2, 0.6 );
}


// Action to animate a battle pass bp increase
function AnimateBattlePointsIncreaseAction( panel, bpAmount, bpValueStart, bpEarnedStart, bpLevelStart )
{
	this.panel = panel;
	this.bpAmount = bpAmount;
	this.bpValueStart = bpValueStart;
	this.bpEarnedStart = bpEarnedStart;
	this.bpLevelStart = bpLevelStart;
}
AnimateBattlePointsIncreaseAction.prototype = new BaseAction();

AnimateBattlePointsIncreaseAction.prototype.start = function ()
{
	this.seq = new RunParallelActions();

	var duration = GetBPIncreaseAnimationDuration( this.bpAmount );
	var levelProgressBar = this.panel.FindChildInLayoutFile( 'BattleLevelProgress' );
	var minLevelBP = Math.min( this.bpLevelStart, levelProgressBar.max );
	var maxLevelBP = Math.min( this.bpLevelStart + this.bpAmount, levelProgressBar.max );

	this.seq.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_level_bp', minLevelBP, maxLevelBP, duration ) );
	this.seq.actions.push( new AnimateProgressBarWithMiddleAction( levelProgressBar, minLevelBP, maxLevelBP, duration ) );
	this.seq.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );

	this.seq.start();
}
AnimateBattlePointsIncreaseAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateBattlePointsIncreaseAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Adds points to totals bar
//-----------------------------------------------------------------------------
function UpdateSubpanelTotalPoints( panel, ownerPanel, bpAmount, bpStartingSubTotal, displayOnly )
{
	panel.SetDialogVariableInt( 'xp_circle_points', bpAmount );
	panel.AddClass( 'ShowTotals' );
	if ( !displayOnly )
	{
		ownerPanel.SetDialogVariableInt( 'total_points_gained', bpStartingSubTotal + bpAmount );
	}
}


//-----------------------------------------------------------------------------
// Subpanel animation timings
//-----------------------------------------------------------------------------
var g_DelayAfterStart = 0.05;
var g_SubElementDelay = 0.05;

//-----------------------------------------------------------------------------
// Animates wagering subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateWageringSubpanelAction( panel, ownerPanel, wagering_data, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.SetDialogVariableInt( 'wager_amount', wagering_data.wager_amount );
	panel.SetDialogVariableInt( 'wager_conversion_ratio', wagering_data.conversion_ratio );
	panel.SetDialogVariableInt( 'wager_token_bonus_pct', wagering_data.wager_token_bonus_pct );
	panel.SetDialogVariableInt( 'wager_streak_bonus_pct', wagering_data.wager_streak_bonus_pct );

	this.total_points = wagering_data.wager_amount * wagering_data.conversion_ratio * ( 100 + wagering_data.wager_streak_bonus_pct + wagering_data.wager_token_bonus_pct ) / 100;
}

AnimateWageringSubpanelAction.prototype = new BaseAction();

AnimateWageringSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowWager' ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTeamWagerBonus' ) );

	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateWageringSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateWageringSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates tipping subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateTippingSubpanelAction( panel, ownerPanel, tips, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	var totalTipCount = 0;
	this.panelCount = 0;
	this.total_points = 0;

	var tipContainer = panel.FindChildInLayoutFile( "TipContainer" );
	var tipContainer2 = panel.FindChildInLayoutFile( "TipContainer2" );
	var tipParent = tipContainer;
	for ( var i = 0; i < tips.length; ++i )
	{
		if ( i == 4 )
		{
			tipParent = tipContainer2;
			panel.AddClass( "TwoTipColumns" );
		}

		var tipperPanel = $.CreatePanel( 'Panel', tipParent, 'Tipper' + i );
		tipperPanel.BLoadLayoutSnippet( 'BattlePassTip' );

		var avatarPanel = tipperPanel.FindChildInLayoutFile( "Avatar" );
		avatarPanel.SetAccountID( tips[i].account_id );

		tipperPanel.SetDialogVariableInt( 'tip_points', tips[i].amount );
		tipperPanel.AddClass( 'TipCount' + tips[i].count );

		totalTipCount += tips[i].count;
		this.panelCount = this.panelCount + 1;
		this.total_points += tips[i].count * tips[i].amount
	}
	panel.SetDialogVariableInt( 'total_tip_count', totalTipCount );
}

AnimateTippingSubpanelAction.prototype = new BaseAction();

AnimateTippingSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTotalTips' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	for ( var i = 0; i < this.panelCount; ++i )
	{
		var tipperPanel = this.panel.FindChildInLayoutFile( 'Tipper' + i );
		this.seq.actions.push( new AddClassAction( tipperPanel, 'ShowTip' ) );
	}

	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}

AnimateTippingSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateTippingSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates actions granted subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateActionsGrantedSubpanelAction( panel, ownerPanel, actions_granted, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	this.panelCount = 0;
	this.total_points = 0;

	var actionContainer = panel.FindChildInLayoutFile( "ActionContainer" );
	for ( var i = 0; i < actions_granted.length; ++i )
	{
		var actionPanel = $.CreatePanel( 'Panel', actionContainer, 'Action' + i );
		actionPanel.BLoadLayoutSnippet( 'BattlePassAction' );

		if ( actions_granted[i].action_image != null )
		{
			var imagePanel = actionPanel.FindChildInLayoutFile( "ConsumableImage" );
			imagePanel.SetImage( actions_granted[i].action_image );
		}

		actionPanel.SetDialogVariableInt( 'action_points', actions_granted[i].bp_amount );
		actionPanel.SetDialogVariableInt( 'action_quantity', actions_granted[i].quantity );

		this.panelCount = this.panelCount + 1;
		this.total_points += actions_granted[i].quantity * actions_granted[i].bp_amount
	}
}

AnimateActionsGrantedSubpanelAction.prototype = new BaseAction();

AnimateActionsGrantedSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTotalActions' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	for ( var i = 0; i < this.panelCount; ++i )
	{
		var actionPanel = this.panel.FindChildInLayoutFile( 'Action' + i );
		this.seq.actions.push( new AddClassAction( actionPanel, 'ShowAction' ) );
	}

	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}

AnimateActionsGrantedSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateActionsGrantedSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}

//-----------------------------------------------------------------------------
// Animates cavern crawl subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateCavernCrawlSubpanelAction( panel, ownerPanel, cavern_data, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	panel.FindChildInLayoutFile( "CavernCrawlHero" ).heroid = cavern_data.hero_id;

	this.total_points = cavern_data.bp_amount;
}

AnimateCavernCrawlSubpanelAction.prototype = new BaseAction();

AnimateCavernCrawlSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowMap' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateCavernCrawlSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateCavernCrawlSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Event game bp progress
//-----------------------------------------------------------------------------
function AnimateEventGameTI9SubpanelAction( panel, ownerPanel, event_game_ti9, startingPoints ) {
    var kWinPointsBase = 300;

    this.panel = panel;
    this.ownerPanel = ownerPanel;
    this.startingPoints = startingPoints;
    this.total_points = event_game_ti9.bp_amount;
    this.show_win = ( event_game_ti9.win_points > 0 );
    this.show_loss = ( event_game_ti9.loss_points > 0 );
    this.show_daily_bonus = ( event_game_ti9.win_points > kWinPointsBase );
    this.show_treasure = ( event_game_ti9.treasure_points > 0 );

    panel.AddClass( 'Visible' );

    if ( this.show_win )
    {
        panel.AddClass( "EventGame_HasWin" );
    }

    if ( this.show_loss )
    {
        panel.AddClass( "EventGame_HasLoss" );
    }

    if ( this.show_daily_bonus )
    {
        panel.AddClass( "EventGame_HasDailyBonus" );
    }

    if ( this.show_treasure )
    {
        panel.AddClass( "EventGame_HasTreasure" );
    }

    var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
    panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

    panel.SetDialogVariableInt( "win_points", event_game_ti9.win_points > kWinPointsBase ? kWinPointsBase : event_game_ti9.win_points );
    panel.SetDialogVariableInt( "bonus_points", event_game_ti9.win_points - kWinPointsBase );
	panel.SetDialogVariableInt( "loss_points",  event_game_ti9.loss_points );
    panel.SetDialogVariableInt( "treasure_points", event_game_ti9.treasure_points );

    var progressMax = event_game_ti9.weekly_cap_total;
    var progressEnd = progressMax - event_game_ti9.weekly_cap_remaining;
    var progressStart = progressEnd - event_game_ti9.bp_amount;

    panel.SetDialogVariableInt( "weekly_progress", progressEnd );
    panel.SetDialogVariableInt( "weekly_complete_limit", progressMax );

    var progressBar = panel.FindChildInLayoutFile( "EventGameWeeklyProgress" );
    progressBar.max = progressMax;
    progressBar.lowervalue = progressStart;
    progressBar.uppervalue = progressEnd;

}

AnimateEventGameTI9SubpanelAction.prototype = new BaseAction();

AnimateEventGameTI9SubpanelAction.prototype.start = function () {
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

    if ( this.show_win )
    {
        this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowWin' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

        if ( this.show_daily_bonus )
        {
            this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowDailyBonus' ) );
            this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
        }
    }

	if ( this.show_loss )
    {
        this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowLoss' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
    }

    if ( this.show_treasure )
    {
        this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowTreasure' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
    }

    this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowWeeklyProgress' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

    var panel = this.panel;
    var ownerPanel = this.ownerPanel;
    var total_points = this.total_points;
    var startingPoints = this.startingPoints;
    this.seq.actions.push( new RunFunctionAction( function () {
        UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
    } ) );

    this.seq.start();
}
AnimateEventGameTI9SubpanelAction.prototype.update = function () {
    return this.seq.update();
}
AnimateEventGameTI9SubpanelAction.prototype.finish = function () {
    this.seq.finish();
}

//-----------------------------------------------------------------------------
// Event game bp progress
//-----------------------------------------------------------------------------
function AnimateEventGameTI10SubpanelAction(panel, ownerPanel, event_game_ti10, startingPoints)
{
    this.panel = panel;
    this.ownerPanel = ownerPanel;
    this.startingPoints = startingPoints;
    this.total_points = event_game_ti10.bp_amount;
    this.premium_starting_points = event_game_ti10.premium_start;
    this.premium_progress = event_game_ti10.bonus_premium_amount;
    this.show_weekly_progress = (event_game_ti10.bp_amount > 0 );
    this.show_premium_weekly_progress = (event_game_ti10.bonus_premium_amount > 0);

    panel.AddClass( 'Visible' );

    var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
    panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

    panel.SetDialogVariableInt("win_points", event_game_ti10.bp_amount);

    var nPremiumPoints = event_game_ti10.premium_amount;
    var nExtraPremiumPoints = 0;
    if (event_game_ti10.bonus_premium_amount > 0)
    {
        nExtraPremiumPoints = event_game_ti10.premium_amount - event_game_ti10.bonus_premium_amount;
        nPremiumPoints = event_game_ti10.bonus_premium_amount;
    }

    panel.SetDialogVariableInt("premium_points", nPremiumPoints );
    panel.SetDialogVariableInt("extra_premium_points", nExtraPremiumPoints );
    panel.SetHasClass('HasExtraPremiumPoints', nExtraPremiumPoints > 0 );
    panel.SetHasClass('HasBonusPremiumPoints', event_game_ti10.bonus_premium_amount > 0);

    var progressMax = event_game_ti10.bp_max;
    var progressStart = event_game_ti10.bp_start;
    var progressEnd = this.total_points + event_game_ti10.bp_start;

    panel.SetDialogVariableInt( "weekly_progress", this.total_points );
    panel.SetDialogVariableInt( "weekly_start_value", progressStart );
    panel.SetDialogVariableInt( "weekly_complete_limit", progressMax );

    var progressBar = panel.FindChildInLayoutFile( "EventGameWeeklyProgress" );
    progressBar.max = Math.max( progressMax, 1 );
    progressBar.lowervalue = progressStart;
    progressBar.uppervalue = progressEnd;
 
    panel.SetDialogVariableInt("weekly_premium_progress", event_game_ti10.bonus_premium_amount );
    panel.SetDialogVariableInt("weekly_premium_start_value", event_game_ti10.premium_start );
    panel.SetDialogVariableInt("weekly_premium_complete_limit", event_game_ti10.premium_max);

    var progressBar = panel.FindChildInLayoutFile("EventGameWeeklyPremiumProgress");
    progressBar.max = Math.max( event_game_ti10.premium_max, 1 );
    progressBar.lowervalue = event_game_ti10.premium_start;
    progressBar.uppervalue = progressBar.lowervalue;
}

AnimateEventGameTI10SubpanelAction.prototype = new BaseAction();

AnimateEventGameTI10SubpanelAction.prototype.start = function ()
{
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

    if ( this.show_premium_weekly_progress )
    {
        this.seq.actions.push(new AddClassAction(this.panel, 'EventGame_ShowWeeklyPremiumProgress'));
        this.seq.actions.push(new SkippableAction(new WaitAction(g_SubElementDelay)));
    }

    if (this.show_weekly_progress)
    {
        this.seq.actions.push(new AddClassAction(this.panel, 'EventGame_ShowWeeklyProgress'));
        this.seq.actions.push(new SkippableAction(new WaitAction(g_SubElementDelay)));
    }

    var panel = this.panel;
    var ownerPanel = this.ownerPanel;
    var total_points = this.total_points;
    var startingPoints = this.startingPoints;
    this.seq.actions.push(new RunFunctionAction(function ()
    {
        UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
    } ) );

    if (this.show_premium_weekly_progress)
    {
        this.seq.actions.push(new SkippableAction(new WaitAction(0.2)));
        this.seq.actions.push(new AddClassAction(this.panel, 'EventGame_ShowWeeklyPremiumBonus'));

        (function (me) {
            me.seq.actions.push(new RunFunctionAction(function () {
                var progressBar = me.panel.FindChildInLayoutFile("EventGameWeeklyPremiumProgress");
                progressBar.uppervalue = me.premium_starting_points + me.premium_progress;
            }));
        })(this);
    }

    this.seq.start();
}
AnimateEventGameTI10SubpanelAction.prototype.update = function () {
    return this.seq.update();
}
AnimateEventGameTI10SubpanelAction.prototype.finish = function () {
    this.seq.finish();
}

function AnimateEventGameNemesticeSubpanelAction( panel, ownerPanel, event_game_nemestice, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;
	this.total_points = event_game_nemestice.bp_amount;
	this.show_weekly_progress = ( event_game_nemestice.bp_amount > 0 );

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.SetDialogVariableInt( "win_points", event_game_nemestice.bp_amount );

	panel.SetHasClass( 'HasExtraPremiumPoints', false );
	panel.SetHasClass( 'HasBonusPremiumPoints', false );

	var progressMax = event_game_nemestice.bp_max;
	var progressStart = event_game_nemestice.bp_start;
	var progressEnd = this.total_points + event_game_nemestice.bp_start;

	panel.SetDialogVariableInt( "weekly_progress", this.total_points );
	panel.SetDialogVariableInt( "weekly_start_value", progressStart );
	panel.SetDialogVariableInt( "weekly_complete_limit", progressMax );

	var progressBar = panel.FindChildInLayoutFile( "EventGameWeeklyProgress" );
	progressBar.max = Math.max( progressMax, 1 );
	progressBar.lowervalue = progressStart;
	progressBar.uppervalue = progressEnd;
}

AnimateEventGameNemesticeSubpanelAction.prototype = new BaseAction();

AnimateEventGameNemesticeSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	if ( this.show_weekly_progress )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowWeeklyProgress' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
	}

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateEventGameNemesticeSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateEventGameNemesticeSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}

//-----------------------------------------------------------------------------
// Animates daily challenge subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateDailyChallengeSubpanelAction( panel, ownerPanel, daily_challenge, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.FindChildInLayoutFile( "DailyChallengeHeroMovie" ).heroid = daily_challenge.hero_id;

	this.total_points = daily_challenge.bp_amount;
}

AnimateDailyChallengeSubpanelAction.prototype = new BaseAction();

AnimateDailyChallengeSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowHero' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateDailyChallengeSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateDailyChallengeSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates weekly challenge subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateWeeklyChallengeSubpanelAction( panel, ownerPanel, weekly_challenge, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );
	panelXPCircle.SetDialogVariableInt( 'points', 1000 ); // Not sure why this is necesssary, we used to do this?

	panel.SetDialogVariable( 'weekly_challenge_description', weekly_challenge.challenge_description );
	panel.SetDialogVariableInt( 'weekly_progress', weekly_challenge.progress );
	panel.SetDialogVariableInt( 'weekly_complete_limit', weekly_challenge.complete_limit );
	panel.SetDialogVariableInt( 'weekly_increment', weekly_challenge.end_progress - weekly_challenge.progress );

	var progressBar = panel.FindChildInLayoutFile( "WeeklyChallengeProgress" );
	progressBar.max = weekly_challenge.complete_limit;
	progressBar.lowervalue = weekly_challenge.progress;
	progressBar.uppervalue = weekly_challenge.end_progress;

	this.points_for_display = weekly_challenge.bp_amount;
	this.total_points = 0;
	if ( weekly_challenge.end_progress == weekly_challenge.complete_limit )
	{
		this.total_points = weekly_challenge.bp_amount;
	}
	else
	{
		panel.AddClass( "HideXPCircle" );
	}
}

AnimateWeeklyChallengeSubpanelAction.prototype = new BaseAction();

AnimateWeeklyChallengeSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowChallenge' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	if ( this.total_points != 0 )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
	}

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.points_for_display;
	var displayOnly = ( this.total_points == 0 );
	var startingPoints = this.startingPoints;

	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, displayOnly );
	} ) );

	this.seq.start();
}
AnimateWeeklyChallengeSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateWeeklyChallengeSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}

//-----------------------------------------------------------------------------
// Animates Guild subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateGuildSubpanelAction( panel, ownerPanel, guild_progress, startingPoints, event_id )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;
	this.total_points = 0;
	this.guild_progress = guild_progress;

	panel.AddClass( 'Visible' );

	if ( guild_progress.guild_contracts != null && guild_progress.guild_contracts.length > 0 )
	{
		var contractsList = panel.FindChildInLayoutFile( "GuildContractList" );
		for ( var i = 0; i < guild_progress.guild_contracts.length; ++i )
		{
			var guildContract = guild_progress.guild_contracts[i];

			var contractPanel = $.CreatePanel( 'Panel', contractsList, '' );
			contractPanel.BLoadLayoutSnippet( 'BattlePassGuildContract' );
			var contract = contractPanel.FindChildInLayoutFile( 'GuildContract' );
			contract.SetContract( event_id, guildContract.challenge_instance_id, guildContract.challenge_parameter, guildContract.completed );
			contractPanel.SetHasClass( "ContractCompleted", guildContract.completed );
			if (guildContract.completed )
				this.total_points += guildContract.battle_point_reward;
		}

		panel.AddClass( "HasGuildContracts" );
	}

	if ( guild_progress.guild_challenge != null )
	{
		var guildChallenge = guild_progress.guild_challenge;

		var challengeImage = panel.FindChildInLayoutFile( "GuildChallengeImage" );
		challengeImage.SetImage( guildChallenge.challenge_image );

		panel.SetDialogVariableInt( "challenge_start_value", guildChallenge.challenge_start_value );
		panel.SetDialogVariableInt( "challenge_max_value", guildChallenge.challenge_max_value );
		panel.SetDialogVariableInt( "challenge_progress", guildChallenge.challenge_progress );

		var challengeProgressBar = panel.FindChildInLayoutFile( "GuildChallengeProgressBar" );
		challengeProgressBar.min = 0;
		challengeProgressBar.max = guildChallenge.challenge_max_value;
		challengeProgressBar.lowervalue = guildChallenge.challenge_start_value;
		challengeProgressBar.uppervalue = guildChallenge.challenge_start_value + guildChallenge.challenge_progress;

		panel.AddClass( "HasGuildChallenge" );
    }

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );
}

AnimateGuildSubpanelAction.prototype = new BaseAction();

AnimateGuildSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	var contractsList = this.panel.FindChildInLayoutFile( "GuildContractList" );
	if ( contractsList.GetChildCount() > 0 )
	{
		this.seq.actions.push( new AddClassAction( this.panel, "ShowGuildContracts" ) );
		for ( var i = 0; i < contractsList.GetChildCount(); ++i )
		{
			var contractPanel = contractsList.GetChild( i );

			this.seq.actions.push( new RunFunctionAction( ( function ( contract )
			{
				return function () { contract.AddClass( "ShowGuildContract" ) };
			} )( contractPanel ) ) );
			this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
        }
	}

	if ( this.guild_progress.guild_challenge != null )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'ShowGuildChallenge' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
    }

	if ( this.total_points != 0 )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
	}

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var displayOnly = ( this.total_points == 0 );
	var startingPoints = this.startingPoints;

	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, displayOnly );
	} ) );

	this.seq.start();
}
AnimateGuildSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateGuildSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Main entry point for MVP Voting
//-----------------------------------------------------------------------------

function AnimateMVPVotingScreenAction( data )
{
    this.data = data;
}

AnimateMVPVotingScreenAction.prototype = new BaseAction();

AnimateMVPVotingScreenAction.prototype.start = function ()
{
    // Create the screen and do a bunch of initial setup
    var panel = StartNewScreen( 'MVPVotingProgressScreen' );
    panel.BLoadLayoutSnippet( "MVPVotingProgress" );
    var mvpVotePanel = panel.FindChildInLayoutFile( 'PostGameMVPVote' );
    mvpVotePanel.SetMatchID( this.data.mvp_voting_progress.match_id );
    var heroContainer = mvpVotePanel.FindChildInLayoutFile( 'HeroContainer' );
    for ( var i = 0; i < this.data.mvp_voting_progress.match_players.length; ++i )
    {
        var match_player = this.data.mvp_voting_progress.match_players[i];
        var player_slot = match_player.player_slot;
		var player_hero_id = match_player.hero_id;
        var heroInfoPanel = mvpVotePanel.AddHeroPanel( match_player.account_id, match_player.vote_count );
		
        heroInfoPanel.SetDialogVariable( "hero_name_mvp", $.Localize( '#' + match_player.hero_name ) );
        heroInfoPanel.SetDialogVariable( "player_name_mvp", match_player.player_name );
        heroInfoPanel.SetDialogVariableInt( "mvp_kills", match_player.kills );
        heroInfoPanel.SetDialogVariableInt( "mvp_assists", match_player.assists );
        heroInfoPanel.SetDialogVariableInt( "mvp_deaths", match_player.deaths );
		heroInfoPanel.SetDialogVariableInt( "vote_count", match_player.vote_count );
		
        var voteClickArea = heroInfoPanel.FindChildInLayoutFile( 'VoteAreaPanel' );
		var j = i + 1;
		if ( typeof player_slot !== 'undefined' )
        {
			
            // Use this normally when viewing the details
            mvpVotePanel.SetPortraitUnitToPlayerHero( player_slot, player_hero_id, "background_hero_" + j );
			( function ( panel, account_id )
			{
				voteClickArea.SetPanelEvent( 'onactivate', function ()
				{
					$.DispatchEvent( 'PostGameMVPSubmitVote', voteClickArea, account_id );
				});
			})( voteClickArea, match_player.account_id )
        }
        else
        {
            // Use this for testing when we don't actually have match data
            mvpVotePanel.SetPortraitUnitToPlayerHero( i, player_hero_id, "background_hero_" + j );
			( function ( panel, account_id, player_index )
			{
				voteClickArea.SetPanelEvent( 'onactivate', function ()
				{
					$.DispatchEvent( 'PostGameMVPSubmitVoteTest', voteClickArea, player_index + 1 );
				});
			})( voteClickArea, match_player.account_id, i )
        }

        if( match_player.owns_event == 0 )
        {
            heroInfoPanel.AddClass( "NoCurrentBattlepass" );
        }
        else
        {
            var eventShieldPanel = heroInfoPanel.FindChildInLayoutFile( 'BPLevel' );
            eventShieldPanel.SetEventPoints(match_player.event_id, match_player.event_points);
        }
        
    }
    // Setup the sequence of actions to animate the screen
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( mvpVotePanel, 'ShowScreen'));
    this.seq.actions.push( new AddScreenLinkAction( panel, 'MVPProgress', '#DOTAMVPVote_TitleLink' ) );
    this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( mvpVotePanel, 'HasVotedForMVP' ), 25.0 ) );
    this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( mvpVotePanel, 'DidNotVoteForMVP' ), 1.8 ) );
    this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

    this.seq.start();
}
AnimateMVPVotingScreenAction.prototype.update = function ()
{
    return this.seq.update();
}
AnimateMVPVotingScreenAction.prototype.finish = function ()
{
    this.seq.finish();
}

//-----------------------------------------------------------------------------
// Main entry point for battle points animation
//-----------------------------------------------------------------------------


function AnimateBattlePassScreenAction( data )
{
	this.data = data;
}

function ComputeBattlePassTier( tier_list, level )
{
	if ( !tier_list )
		return;

	var tier = 0;
	for ( var i = 0; i < tier_list.length; ++i )
	{
		if ( level >= tier_list[i] )
		{
			tier = i;
		}
	}

	return tier;
}

AnimateBattlePassScreenAction.prototype = new BaseAction();

AnimateBattlePassScreenAction.prototype.start = function ()
{
	var battlePointsStart = this.data.battle_pass_progress.battle_points_start;
	var battleLevelStart = Math.floor( battlePointsStart / this.data.battle_pass_progress.battle_points_per_level );
	var heroID = this.data.hero_id;

	var battlePointsAtLevelStart = battleLevelStart * this.data.battle_pass_progress.battle_points_per_level;

	var bpLevelStart = 0;
	var bpLevelNext = 0;
	bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
	bpLevelNext = this.data.battle_pass_progress.battle_points_per_level;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'BattlePassProgressScreen' );
	panel.BLoadLayoutSnippet( "BattlePassProgress" );

	panel.SetDialogVariableInt( 'total_points_gained', 0 );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.actions.push( new AddScreenLinkAction( panel, 'BattlePassProgress', '#DOTA_PlusPostGame_BattlePassProgress', function ()
	{
		panel.SwitchClass( 'current_screen', 'ShowBattlePassProgress' );
	} ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowBattlePassProgress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	var subPanelActions = new RunSkippableStaggeredActions( .3 );

	var startingPointsToAdd = 0;
	var panelCount = 0;
	var kMaxPanels = 6;

	if ( this.data.battle_pass_progress.event_game_ti9 != null )
	{
        var eventPanel = panel.FindChildInLayoutFile( "BattlePassEventGameTI9Progress" );
        var subpanelAction = new AnimateEventGameTI9SubpanelAction( eventPanel, panel, this.data.battle_pass_progress.event_game_ti9, startingPointsToAdd );
	    startingPointsToAdd += subpanelAction.total_points;
	    subPanelActions.actions.push( subpanelAction );
	    if ( ++panelCount > kMaxPanels )
	        eventPanel.RemoveClass( 'Visible' );
	}

    if ( this.data.battle_pass_progress.event_game_ti10 != null )
    {
        var eventPanel = panel.FindChildInLayoutFile("BattlePassEventGameTI10Progress");
        var subpanelAction = new AnimateEventGameTI10SubpanelAction(eventPanel, panel, this.data.battle_pass_progress.event_game_ti10, startingPointsToAdd);
        startingPointsToAdd += subpanelAction.total_points;
        subPanelActions.actions.push(subpanelAction);
        if (++panelCount > kMaxPanels)
            eventPanel.RemoveClass('Visible');
	}

	if ( this.data.battle_pass_progress.cavern_crawl != null )
	{
	    var cavernPanel = panel.FindChildInLayoutFile( "BattlePassCavernCrawlProgress" );
	    var subpanelAction = new AnimateCavernCrawlSubpanelAction( cavernPanel, panel, this.data.battle_pass_progress.cavern_crawl, startingPointsToAdd );
	    startingPointsToAdd += subpanelAction.total_points;
	    subPanelActions.actions.push( subpanelAction );
	    if ( ++panelCount > kMaxPanels )
	        cavernPanel.RemoveClass( 'Visible' );
	}

	if ( this.data.battle_pass_progress.wagering != null )
	{
		var wagerPanel = panel.FindChildInLayoutFile( "BattlePassWagerProgress" );
		var subpanelAction = new AnimateWageringSubpanelAction( wagerPanel, panel, this.data.battle_pass_progress.wagering, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    wagerPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.tips != null && this.data.battle_pass_progress.tips.length != 0 )
	{
		var tipPanel = panel.FindChildInLayoutFile( "BattlePassTipsProgress" );
		var subpanelAction = new AnimateTippingSubpanelAction( tipPanel, panel, this.data.battle_pass_progress.tips, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    tipPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.actions_granted != null && this.data.battle_pass_progress.actions_granted.length != 0 )
	{
		var actionPanel = panel.FindChildInLayoutFile( "BattlePassActionsGrantedProgress" );
		var subpanelAction = new AnimateActionsGrantedSubpanelAction( actionPanel, panel, this.data.battle_pass_progress.actions_granted, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    actionPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.daily_challenge != null )
	{
		var dailyPanel = panel.FindChildInLayoutFile( "BattlePassDailyChallengeProgress" );
		var subpanelAction = new AnimateDailyChallengeSubpanelAction( dailyPanel, panel, this.data.battle_pass_progress.daily_challenge, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    dailyPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.weekly_challenge_1 != null )
	{
		var weeklyPanel = panel.FindChildInLayoutFile( "BattlePassWeeklyChallengeProgress" );
		var subpanelAction = new AnimateWeeklyChallengeSubpanelAction( weeklyPanel, panel, this.data.battle_pass_progress.weekly_challenge_1, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    weeklyPanel.RemoveClass( 'Visible' );
	}

	if ( this.data.battle_pass_progress.guild_progress != null )
	{
		var guildPanel = panel.FindChildInLayoutFile( "BattlePassGuildProgress" );
		var subpanelAction = new AnimateGuildSubpanelAction( guildPanel, panel, this.data.battle_pass_progress.guild_progress, startingPointsToAdd, this.data.battle_pass_progress.battle_points_event_id );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
			guildPanel.RemoveClass( 'Visible' );
    }

	this.seq.actions.push( subPanelActions );

	this.seq.actions.push( new AnimateBattlePassLevelsAction( panel,
        this.data.battle_pass_progress.battle_points_event_id,
        this.data.battle_pass_progress.battle_points_start,
        this.data.battle_pass_progress.battle_points_per_level,
        startingPointsToAdd ) );

	this.seq.actions.push( new WaitAction( 0.2 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateBattlePassScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateBattlePassScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}



// Frostivus 2018

function AnimateFrostivusScreenAction( data )
{
	this.data = data;
}

AnimateFrostivusScreenAction.prototype = new BaseAction();

AnimateFrostivusScreenAction.prototype.start = function ()
{
	var battlePointsStart = this.data.frostivus_progress.battle_points_start;
	var battleLevelStart = Math.floor( battlePointsStart / this.data.frostivus_progress.battle_points_per_level );
	var heroID = this.data.hero_id;

	var battlePointsAtLevelStart = battleLevelStart * this.data.frostivus_progress.battle_points_per_level;

	var bpLevelStart = 0;
	var bpLevelNext = 0;
	bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
	bpLevelNext = this.data.frostivus_progress.battle_points_per_level;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'Frostivus2018ProgressScreen' );
	panel.BLoadLayoutSnippet( "Frostivus2018Progress" );

	panel.SetDialogVariableInt( 'total_points_gained', 0 );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.actions.push( new AddScreenLinkAction( panel, 'Frostivus2018Progress', '#DOTA_PlusPostGame_Frostivus2018Progress', function ()
	{
		panel.SwitchClass( 'current_screen', 'ShowFrostivus2018Progress' );
	} ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowFrostivus2018Progress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	( function ( me, myPanel )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				myPanel.SetDialogVariableInt( 'total_points_gained', me.data.frostivus_progress.battle_points_earned );
			} ) );
	} )( this, panel );

	//panel.FindChildInLayoutFile( "Frostivus2018TotalsRow" ).SetDialogVariableInt( 'bp_value', 0 );
	panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
	panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
	panel.FindChildInLayoutFile( 'Frostivus2018LevelShield' ).SetEventLevel( this.data.frostivus_progress.battle_points_event_id, battleLevelStart );

	this.seq.actions.push( new SkippableAction( new WaitAction( 0.75 ) ) );

	var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
	progressBar.max = bpLevelNext;
	progressBar.lowervalue = bpLevelStart;
	progressBar.uppervalue = bpLevelStart;

	var bpEarned = 0;
	var bpLevel = bpLevelStart;
	var battleLevel = battleLevelStart;

	var bpRemaining = this.data.frostivus_progress.battle_points_earned;
	var bpEarnedOnRow = 0;

	while ( bpRemaining > 0 )
	{
		var bpToAnimate = 0;
		var bpToNextLevel = 0;
		bpToNextLevel = bpLevelNext - bpLevel;
		bpToAnimate = Math.min( bpRemaining, bpToNextLevel );

		if ( bpToAnimate > 0 )
		{
			this.seq.actions.push( new SkippableAction( new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) ) );

			bpEarned += bpToAnimate;
			bpLevel += bpToAnimate;
			bpEarnedOnRow += bpToAnimate;
			bpRemaining -= bpToAnimate;
		}

		bpToNextLevel = bpLevelNext - bpLevel;

		if ( bpToNextLevel != 0 )
			continue;

		battleLevel = battleLevel + 1;
		bpLevel = 0;

		this.seq.actions.push( new AddClassAction(panel, 'LeveledUpStart') );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'Frostivus2018LevelShield' );
				levelShield.AddClass( 'LeveledUp' );
				levelShield.SetEventLevel( me.data.frostivus_progress.battle_points_event_id, battleLevelInternal );
			} ) );
		} )( this, battleLevel );

		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
		this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'Frostivus2018LevelShield' );
				levelShield.RemoveClass( 'LeveledUp' );
			} ) );
		} )( this, battleLevel );
		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

		( function ( me, bpLevelInternal, bpLevelNextInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				progressBar.lowervalue = 0;
				progressBar.uppervalue = 0;
				panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
				panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
			} ) );
		} )( this, bpLevel, bpLevelNext );
	}

	this.seq.actions.push( new WaitAction( 0.2 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateFrostivusScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateFrostivusScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// Event Points [New Bloom 2019, etc]

function AnimateEventPointsScreenAction( data )
{
	this.data = data;
}

AnimateEventPointsScreenAction.prototype = new BaseAction();

AnimateEventPointsScreenAction.prototype.start = function ()
{
	var battlePointsStart = this.data.event_points_progress.battle_points_start;
	var battleLevelStart = Math.floor( battlePointsStart / this.data.event_points_progress.battle_points_per_level );
	var heroID = this.data.hero_id;

	var battlePointsAtLevelStart = battleLevelStart * this.data.event_points_progress.battle_points_per_level;

	var bpLevelStart = 0;
	var bpLevelNext = 0;
	bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
	bpLevelNext = this.data.event_points_progress.battle_points_per_level;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'EventPointsProgressScreen' );
	panel.BLoadLayoutSnippet( "EventPointsProgress" );

	panel.SetDialogVariableInt( 'total_points_gained', 0 );

	panel.SetDialogVariable( 'event_name', $.Localize( this.data.event_points_progress.battle_points_event_name ) );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.actions.push( new AddScreenLinkAction( panel, 'EventPointsProgress', '#DOTA_PlusPostGame_EventPointsProgress', function ()
	{
		panel.SwitchClass( 'current_screen', 'ShowEventPointsProgress' );
	} ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowEventPointsProgress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	( function ( me, myPanel )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				myPanel.SetDialogVariableInt( 'total_points_gained', me.data.event_points_progress.battle_points_earned );
			} ) );
	} )( this, panel );

	//panel.FindChildInLayoutFile( "EventPointsTotalsRow" ).SetDialogVariableInt( 'bp_value', 0 );
	panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
	panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
	panel.FindChildInLayoutFile( 'EventPointsLevelShield' ).SetEventLevel( this.data.event_points_progress.battle_points_event_id, battleLevelStart );

	this.seq.actions.push( new SkippableAction( new WaitAction( 0.75 ) ) );

	var wonGameRow = panel.FindChildInLayoutFile( "EventPointsWonGameRow" );
	this.seq.actions.push( new AddClassAction( wonGameRow, 'ShowRow' ) );
	this.seq.actions.push( new AddClassAction( wonGameRow, 'ShowValue' ) );

	var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
	progressBar.max = bpLevelNext;
	progressBar.lowervalue = bpLevelStart;
	progressBar.uppervalue = bpLevelStart;

	var bpEarned = 0;
	var bpLevel = bpLevelStart;
	var battleLevel = battleLevelStart;

	var bpRemaining = this.data.event_points_progress.battle_points_earned;
	var bpEarnedOnRow = 0;

	while ( bpRemaining > 0 )
	{
		var bpToAnimate = 0;
		var bpToNextLevel = 0;
		bpToNextLevel = bpLevelNext - bpLevel;
		bpToAnimate = Math.min( bpRemaining, bpToNextLevel );

		if ( bpToAnimate > 0 )
		{
			this.seq.actions.push( new SkippableAction( new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) ) );

			bpEarned += bpToAnimate;
			bpLevel += bpToAnimate;
			bpEarnedOnRow += bpToAnimate;
			bpRemaining -= bpToAnimate;
		}

		bpToNextLevel = bpLevelNext - bpLevel;

		if ( bpToNextLevel != 0 )
			continue;

		battleLevel = battleLevel + 1;
		bpLevel = 0;

		this.seq.actions.push( new AddClassAction(panel, 'LeveledUpStart') );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'EventPointsLevelShield' );
				levelShield.AddClass( 'LeveledUp' );
				levelShield.SetEventLevel( me.data.event_points_progress.battle_points_event_id, battleLevelInternal );
			} ) );
		} )( this, battleLevel );

		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
		this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'EventPointsLevelShield' );
				levelShield.RemoveClass( 'LeveledUp' );
			} ) );
		} )( this, battleLevel );
		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

		( function ( me, bpLevelInternal, bpLevelNextInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				progressBar.lowervalue = 0;
				progressBar.uppervalue = 0;
				panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
				panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
			} ) );
		} )( this, bpLevel, bpLevelNext );
	}

	this.seq.actions.push( new WaitAction( 0.2 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateEventPointsScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateEventPointsScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// ----------------------------------------------------------------------------
//
// Gauntlet Progress screen
//
// ----------------------------------------------------------------------------
function AnimateGauntletProgressScreenAction( data, gauntlet )
{
    this.data = data;
    this.gauntlet = gauntlet;
}

AnimateGauntletProgressScreenAction.prototype = new BaseAction();

AnimateGauntletProgressScreenAction.prototype.start = function ()
{
    // n.b. these are before this update
    var nWins = this.gauntlet.wins;
    var nLosses = this.gauntlet.losses;
    var bWin = !!this.gauntlet.win_game;
    var nTier = this.gauntlet.tier;
    var nTierBPAward = this.gauntlet.bp_award;
    var nGoldAward = this.gauntlet.gold_award;
    var nShardAward = this.gauntlet.shard_award;

    var bFinished = ( bWin && nWins >= 2 ) || ( !bWin && nLosses >= 1 );
    
    var nBPAwarded = 0;
    if ( bFinished && bWin )
    {
        nBPAwarded = nTierBPAward;
    }

    var panel = StartNewScreen( 'GauntletProgressScreen' );
    panel.BLoadLayoutSnippet( "GauntletProgress" );

    panel.SetDialogVariableInt( 'total_points_gained', 0 );
    panel.SetDialogVariableInt( 'gauntlet_gold', 0 );
    panel.SetDialogVariableInt( 'gauntlet_shards', 0 );
    panel.SetDialogVariable( 'gauntlet_tier_name', $.Localize( '#DOTA_GauntletTierName_' + nTier ) );

    // Set initial state
    for ( var i = 0; i < nWins; ++i )
    {
        var pipPanel = panel.FindChildInLayoutFile( 'GauntletWin' + i );
        if ( pipPanel == null )
            break;

        pipPanel.AddClass( 'PipActive' );
    }

    for ( var i = 0; i < nLosses; ++i )
    {
        var pipPanel = panel.FindChildInLayoutFile( 'GauntletLose' + i );
        if ( pipPanel == null )
            break;

        pipPanel.AddClass( 'PipActive' );
    }

    // Only show additional points if we won the whole gauntlet
    if ( nBPAwarded == 0 )
    {
        panel.AddClass( 'HideAdditionalBattlePoints' );
    }

    const ANIMATE_PIP_WIN_X = 841;
    const ANIMATE_PIP_WIN_Y = 624;
    const ANIMATE_PIP_WIN_OFFSET = 64;
    const ANIMATE_PIP_LOSE_X = 1070;
    const ANIMATE_PIP_LOSE_Y = 624;
    const ANIMATE_PIP_LOSE_OFFSET = 64;

    var newPipPanel = panel.FindChildInLayoutFile( 'GauntletAnimatePip' );
    var resultPipPanel = null;
    if( newPipPanel )
    {
        if ( bWin )
        {
            newPipPanel.AddClass( 'GauntletWin' );
            newPipPanel.SetPositionInPixels( ANIMATE_PIP_WIN_X + ANIMATE_PIP_WIN_OFFSET * nWins, ANIMATE_PIP_WIN_Y, 0 );
            resultPipPanel = panel.FindChildInLayoutFile( 'GauntletWin' + nWins );
        }
        else
        {
            newPipPanel.AddClass( 'GauntletLose' );
            newPipPanel.SetPositionInPixels( ANIMATE_PIP_LOSE_X + ANIMATE_PIP_LOSE_OFFSET * nLosses, ANIMATE_PIP_LOSE_Y, 0 );
            resultPipPanel = panel.FindChildInLayoutFile( 'GauntletLose' + nLosses );
        }
    }

    // animation begins 

    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
    this.seq.actions.push( new AddScreenLinkAction( panel, 'GauntletProgress', '#DOTA_GauntletPostGame_Tooltip' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    // gauntlet-specific stuff starts here

    if ( newPipPanel != null )
    {
        this.seq.actions.push( new AddClassAction( newPipPanel, 'Animate' ) );
        this.seq.actions.push( new AddClassAction( panel, 'GauntletScreenShake' ) );

        // wait for anim to complete, then remove anim classes and replace with active pip directly
        this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
        this.seq.actions.push( new OptionalSkippableAction( new PlaySoundAction( bWin ? 'UI.Gauntlet.WinStamp' : 'UI.Gauntlet.LoseStamp' ) ) );

        if ( resultPipPanel != null )
        {
            this.seq.actions.push( new AddClassAction( resultPipPanel, 'PipActive' ) );
        }

        this.seq.actions.push( new SkippableAction( new WaitAction( 0.7 ) ) );

        this.seq.actions.push( new RemoveClassAction( newPipPanel, 'Animate' ) );
        this.seq.actions.push( new RemoveClassAction( panel, 'GauntletScreenShake' ) );
    }

    var resultClass = 'GauntletShowInProgress';
    if ( bFinished )
    {
        if ( bWin )
        {
            resultClass = 'GauntletShowWin';
            if( nTier < 10 )
            {
                resultClass = 'GauntletShowPromote';
                panel.SetDialogVariable( 'promote_tier_name', $.Localize( '#DOTA_GauntletTierName_' + (nTier+1) ) );
            }
        }
        else
        {
            resultClass = 'GauntletShowLose';
        }
    }

    this.seq.actions.push( new AddClassAction( panel, resultClass ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
    if ( bFinished && bWin )
        this.seq.actions.push( new OptionalSkippableAction( new PlaySoundAction( 'UI.Gauntlet.Award' ) ) );

    if ( bFinished && bWin && nGoldAward > 0 )
    {
        this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        var par = new RunParallelActions();
        var duration = GetXPIncreaseAnimationDuration( nGoldAward );
        par.actions.push( new AnimateDialogVariableIntAction( panel, 'gauntlet_gold', 0, nGoldAward, duration ) );
        par.actions.push( new PlaySoundAction( "Plus.shards_tally", duration ) );
        this.seq.actions.push( new SkippableAction( par ) );
    }

    if ( bFinished && bWin && nShardAward > 0 )
    {
        this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        var par = new RunParallelActions();
        var duration = GetXPIncreaseAnimationDuration( nShardAward );
        par.actions.push( new AnimateDialogVariableIntAction( panel, 'gauntlet_shards', 0, nShardAward, duration ) );
        par.actions.push( new PlaySoundAction( "Plus.shards_tally" ) );
        this.seq.actions.push( new SkippableAction( par ) );
    }

    if ( nBPAwarded > 0 )
    {
        this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

        this.seq.actions.push( new RunFunctionAction( function () {
            panel.SetDialogVariableInt( 'total_points_gained', nBPAwarded );
        } ) );

        var par = new RunParallelActions();
        par.actions.push( new AnimateDialogVariableIntAction( panel, 'total_points_gained', 0, nBPAwarded, 1 ) );
        par.actions.push( new AnimateBattlePassLevelsAction( panel,
            this.gauntlet.battle_points_event_id,
            this.gauntlet.battle_points_start,
            this.gauntlet.battle_points_per_level,
            nBPAwarded ) );
        this.seq.actions.push( new SkippableAction( par ) );
    }
    else
    {
        // Need to create this to initialize state even when no BP awarded
        this.seq.actions.push( new AnimateBattlePassLevelsAction( panel,
            this.gauntlet.battle_points_event_id,
            this.gauntlet.battle_points_start,
            this.gauntlet.battle_points_per_level,
            nBPAwarded ) );
    }

    // end of gauntlet-specific stuff

    this.seq.actions.push( new StopSkippingAheadAction() );
    this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
    this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    // animation done, start it
    this.seq.start();
}

AnimateGauntletProgressScreenAction.prototype.update = function () {
    return this.seq.update();
}
AnimateGauntletProgressScreenAction.prototype.finish = function () {
    this.seq.finish();
}


// ----------------------------------------------------------------------------
//
// Player Match Survey Screen
//
// ----------------------------------------------------------------------------
function AnimatePlayerMatchSurveyScreenAction( data )
{
	this.data = data;
}

AnimatePlayerMatchSurveyScreenAction.prototype = new BaseAction();

AnimatePlayerMatchSurveyScreenAction.prototype.start = function ()
{
	var data = this.data;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'PlayerMatchSurveyScreen' );
	panel.BLoadLayoutSnippet( "PlayerMatchSurvey" );

	var goodRatingContainer = panel.FindChildInLayoutFile( 'GoodRatingContainer' );
	var badRatingContainer = panel.FindChildInLayoutFile( 'BadRatingContainer' );
	var skipButton = panel.FindChildInLayoutFile( 'SkipButton' );

	var SubmitRating = function ( nRating, nFlags )
	{
		if( !data.match_id || data.match_id == '0' )
		{
			data.match_id = 0;
		}
		$.DispatchEvent( 'DOTAMatchSubmitPlayerMatchSurvey', data.match_id, nRating, nFlags );

		// Once a rating has been changed, disable all the other UI
		goodRatingContainer.enabled = false;
		badRatingContainer.enabled = false;
		
		PlayUISoundScript( "ui_goto_player_page" );	
	};

	for ( var i = 1; i < goodRatingContainer.GetChildCount() ; ++i )
	{
		var goodRatingButton = goodRatingContainer.GetChild( i );
		var nRating = goodRatingButton.GetAttributeInt("rating_flag", 0);

		var reg = function( goodRatingButton, nRating )
		{
			$.RegisterEventHandler('Activated', goodRatingButton, function ( )
			{
				goodRatingButton.AddClass( 'Selected' );
				SubmitRating( 1, nRating );
			});
		};
		reg( goodRatingButton, nRating );
	}

	for ( var i = 1; i < badRatingContainer.GetChildCount() ; ++i )
	{
		var badRatingButton = badRatingContainer.GetChild( i );
		var nRating = badRatingButton.GetAttributeInt("rating_flag", 0);
		var reg = function( badRatingButton, nRating )
		{
			$.RegisterEventHandler('Activated', badRatingButton, function ( )
			{
				badRatingButton.AddClass( 'Selected' );
				SubmitRating( -1, nRating );
			});
		};
		reg( badRatingButton, nRating );
	}

	// scramble the buttons to avoid bias
	for ( var k = 0 ; k < 5 ; ++ k)
	{
		for ( var i = 1; i < goodRatingContainer.GetChildCount() ; ++i )
		{
			var randint = Math.floor( (goodRatingContainer.GetChildCount()-1)*Math.random() ) + 1; 
			var button = goodRatingContainer.GetChild( i );
			goodRatingContainer.MoveChildAfter( button, goodRatingContainer.GetChild(randint) );
		}
		for ( var i = 1; i < badRatingContainer.GetChildCount() ; ++i )
		{
			var randint = Math.floor( (badRatingContainer.GetChildCount()-1)*Math.random() ) + 1; 
			var button = badRatingContainer.GetChild( i );
			badRatingContainer.MoveChildAfter( button, badRatingContainer.GetChild(randint) );
		}
	}


	$.RegisterEventHandler('Activated', skipButton, function ()
	{
		skipButton.AddClass( 'Selected' );
		panel.AddClass("Skipped")
		SubmitRating( 0, 0 );
	});

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new AddScreenLinkAction( panel, 'PlayerMatchSurveyProgress', '#DOTA_PlayerMatchSurveyPostGame_PlayerMatchSurvey', function ()
	{
		panel.AddClass( 'RatingScreenForceVisible' );
	}));
	this.seq.actions.push( new WaitAction( 0.25 ) );
	this.seq.actions.push( new AddClassAction( panel, 'RatingScreenVisible' ) );

	var durationAction = new RunUntilSingleActionFinishedAction();
	durationAction.actions.push( new WaitForSurveyStateChange( panel ) );
	this.seq.actions.push( durationAction );

	this.seq.actions.push( new AddClassAction( panel, 'HideSkipButton' ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );
	
	this.seq.actions.push( new PlaySoundAction( "ui_hero_select_slide_late" ) );
	this.seq.actions.push( new AddClassAction( panel, 'SubmitFeedbackVisible' ) );

	this.seq.actions.push( new WaitAction( 1.25 ) );
	this.seq.actions.push( new RemoveClassAction( panel, 'RatingScreenVisible' ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );

	this.seq.start();
}

AnimatePlayerMatchSurveyScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimatePlayerMatchSurveyScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// ----------------------------------------------------------------------------
// MVP v2
// ----------------------------------------------------------------------------

function AnimateMVP2ScreenAction( data )
{
	this.data = data;
}

/// base class in post_game_mvp.js
// this version hosts it in a different panel and sets a bool that changes some timing inside AnimateMVP2TabAction.init
AnimateMVP2ScreenAction.prototype = new AnimateMVP2TabAction();

AnimateMVP2ScreenAction.prototype.start = function ()
{
	// Create the screen and do a bunch of initial setup
	var mvp2ScreenPanel = StartNewScreen( 'MVP2Screen' );
	mvp2ScreenPanel.BLoadLayoutSnippet("MVP2Screen");

	this.data.bProgressVersion = true;
	
	this.init( mvp2ScreenPanel );
}

// ----------------------------------------------------------------------------
// Diretide 2020 reward screen
// ----------------------------------------------------------------------------
function AnimateDiretideRewardsScreenAction( data )
{
	this.data = data;
}

AnimateDiretideRewardsScreenAction.prototype = new BaseAction();

AnimateDiretideRewardsScreenAction.prototype.start = function()
{
	var rootPanel = $( '#Diretide2020RewardsScreen' );
	if ( rootPanel !== null )
	{
		rootPanel.DeleteAsync( 0 );
		rootPanel = null;
	}

	var rootPanel = StartNewScreen( 'Diretide2020RewardsScreen' );
	rootPanel.BLoadLayout( 'file://{resources}/layout/diretide/post_game_diretide.xml', false, false );
 	this.seq = rootPanel.CreatePostgameAction( this.data );
	this.seq.start();
	var screenLinksContainer = $.GetContextPanel().GetParent().FindPanelInLayoutFile( 'ProgressScreenButtons' );
	if ( screenLinksContainer.FindChildInLayoutFile( 'DireTide' ) === null )
	{
		var link = $.CreatePanel( 'Button', screenLinksContainer, 'DireTide' );
		link.AddClass( 'ProgressScreenButton' );
		link.AddClass( 'DiretideProgress' );
		var me = this;
		link.SetPanelEvent( 'onactivate', function ()
		{

			$.DispatchEvent( 'DOTAPostGameProgressShowSummary', rootPanel );
			var seq = new RunSequentialActions();
			seq.actions.push( new RunFunctionAction( function () 
			{
				screenLinksContainer.enabled = false;
			}));		
			seq.actions.push( me );
			seq.actions.push( new RunFunctionAction( function () 
			{
				screenLinksContainer.enabled = true;
			}));		
			RunSingleAction( seq );
		} );
	}
}

AnimateDiretideRewardsScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateDiretideRewardsScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}


function TestAnimateBattlePass()
{
	var data =
	{
		hero_id: 87,

		battle_pass_progress:
		{
			battle_points_event_id: 29,
			battle_points_start: 74850,
			battle_points_per_level: 1000,

			wagering:
			{
				wager_amount: 2,
				conversion_ratio: 100,
				wager_token_bonus_pct: 25,
				wager_streak_bonus_pct: 10,
			},

			tips:
			[
				{
					account_id: 172258,
					count: 2,
					amount: 250,
				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 3,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 172258,
//					count: 2,
//					amount: 250,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 3,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
			],

			cavern_crawl:
			{
				hero_id: 87,
				bp_amount: 375,
			},
			
 //           event_game_ti9:
 //           {
 //               bp_amount: 1200,
 //               win_points: 1000,
 //               loss_points: 0,
 //               treasure_points: 200,
 //               weekly_cap_remaining: 1000,
 //               weekly_cap_total: 3000,
 //           },
 //
            event_game_ti10:
            {
                bp_amount: 1200,
                premium_amount: 500,
                bonus_premium_amount: 500,
                bp_start: 350,
                bp_max: 2000,
                premium_start: 2250,
                premium_max: 2500,
            },

			//daily_challenge:
			//{
			//	hero_id: 87,
			//	bp_amount: 125,
			//},

			//weekly_challenge_1:
			//{
			//	challenge_description: 'Kill 50 enemy heroes',
			//	progress: 20000,
			//	end_progress: 30000,
			//	complete_limit: 50000,
			//	bp_amount: 250,
			//},

			actions_granted:
			[
				{
					action_id: 704,
					quantity: 2,
					bp_amount: 100,
					action_image: "file://{images}/spellicons/consumables/seasonal_ti9_shovel.png"
				},
				{
					action_id: 705,
					quantity: 1,
					bp_amount: 5000,
					action_image: "file://{images}/spellicons/consumables/seasonal_ti9_shovel.png"
				},
			],

			guild_progress:
			{
				guild_contracts:
				[
					{
						challenge_instance_id: 2152900061,
						challenge_parameter: 23,
						completed: true,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
					{
						challenge_instance_id: 2506886225,
						challenge_parameter: 22000,
						completed: true,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
					{
						challenge_instance_id: 2506886225,
						challenge_parameter: 22000,
						completed: false,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
				],

				guild_challenge:
				{
					challenge_image: "file://{images}/guilds/challenges/guild_networth_by_time.png",
					challenge_start_value: 1234,
					challenge_max_value: 4500,
					challenge_progress: 400
                }
            }
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateGauntletProgress()
{
    var data =
    {
        hero_id: 87,
        gauntlet_progress:
        {
            tier: 4,
            wins: 2,
            losses: 0,
            win_game: 1,
            bp_award: 1500,
            gold_award: 200,
            shard_award: 1000,

            battle_points_event_id: 29,
            battle_points_start: 73295,
            battle_points_per_level: 1000
        }
    }

    TestProgressAnimation( data );
}


function TestAnimateCavernCrawl()
{
	var data =
	{
		hero_id: 92,
		cavern_crawl_progress:
		{
            event_id: 29,
            map_variant: 0,
            turbo_mode: false,
            map_progress:
                [
                    {
                        path_id_completed: 0,
                        room_id_claimed: 1,
                    }
                ],
 		},
	};

	TestProgressAnimation( data );
}


function TestAnimateRubickArcanaProgress()
{
	var data =
	{
		hero_id: 86,

		rubick_arcana_progress:
		{
			arcana_start_score: 34,
			arcana_end_score: 36
		}
	};

	TestProgressAnimation( data );
}


function TestAnimateWraithKingArcanaProgress()
{
	var data =
	{
		hero_id: 42,

		wraith_king_arcana_progress:
        {
            previous_heroes_killed_mask:
                [  
                    1, 2, 3, 4, 5
                ],
            heroes_killed:
                [
                    6, 82
                ]
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateFrostivusProgress()
{
	var data =
	{
		hero_id: 87,
		frostivus_progress:
		{
			battle_points_event_id: 24,
			battle_points_start: 2200,
			battle_points_per_level: 1000,
			battle_points_earned: 1250,
			battle_points_daily_bonus_earned: 1000,
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateEventPointsProgress()
{
	$.GetContextPanel().AddClass( 'Season_NewBloom2019' );
	var data =
	{
		hero_id: 87,
		event_points_progress:
		{
			battle_points_event_id: 24,
			battle_points_start: 2200,
			battle_points_per_level: 1000,
			battle_points_earned: 1250,
			battle_points_event_name: '#DOTA_EventName_NewBloom2019',
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateDiretideProgress()
{
	$.GetContextPanel().AddClass( 'Season_Diretide2020' );
	var data =
	{
		hero_id: 87,
		player_slot: 3,
		diretide_rewards_progress:
        {
			match_id: '1000030665004',
			awards : 
			[
				{
					award_name: '#DOTA_Diretide_Candy_Reason7',
					award_amounts: [ 35 ],
					award_player_slots : [ 2 ]
				},
				{
					award_name: '#DOTA_Diretide_Candy_Reason2',
					award_amounts: [ 25, 25, 25, 25, 25 ],
					award_player_slots : [ 0, 1, 2, 3, 4 ]
				},
				{
					award_name: '#DOTA_Diretide_Candy_Reason9',
					award_amounts: [ 25, 125, 45 ],
					award_player_slots : [ 1, 2, 3 ]
				},
				{
					award_name: '#DOTA_Diretide_Candy_Reason1',
					award_amounts: [ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ],
					award_player_slots : [ 0, 1, 2, 3, 4, 128, 129, 130, 131, 132]				
				},
			],

			items :
			[
				{
					item_id: 13780, /* Treasure 3 */
					item_player_slot: 1,
					item_image: ""
				},
				{
					item_id: 17626, /* Treasure 3 */
					item_player_slot: 2,
					item_image: ""
				},
				{
					item_id: 13812,
					item_player_slot: 2,
					item_image: "file://{images}/events/diretide/spray.png"
				}
			],
			
            match_players:
            [
                {
					player_slot: 0,
                    player_name: 'Eric L',
                    event_points: 0,
                    account_id: 85501006,
					owns_event: 0
                },
                {
					player_slot: 1,
					player_name: 'Greg',
                    event_points: 450,
                    account_id: 146131,
					owns_event: 1
                },
                {
					player_slot: 2,
                    event_points: 45,
                    player_name: 'AlexF',
                    account_id: 156258214,
					owns_event: 1
                },
                {
					player_slot: 3,
                    event_points: 92,
                    player_name: 'bradm',
                    account_id: 85501369,
					owns_event: 1
                },
                {
					player_slot: 4,
                    event_points: 11,
                    player_name: 'anishc',
                    account_id: 85501621,
					owns_event: 0
				},
				{
					player_slot: 128,
                    event_points: 60,
                    player_name: 'BoyangZ',
                    account_id: 85501128,
					owns_event: 0
                },
                {
					player_slot: 129,
                    event_points: 0,
                    player_name: 'irvz',
                    account_id: 85502069,
					owns_event: 1
                },
                {
					player_slot: 130,
                    event_points: 22,
                    player_name: 'CameronC',
                    account_id: 85501829,
					owns_event: 1
                },
                {
					player_slot: 131,
                    event_points: 50,
                    player_name: 'Alireza',
                    account_id: 170021,
					owns_event: 1
                },
                {
					player_slot: 132,
                    event_points: 5067,
                    player_name: 'philco',
                    account_id: 70071,
					owns_event: 0
                }

            ]
        }

	};

	TestProgressAnimation( data );
}

function TestMVPVotingProgress() {
 
    var data =
	{
	    mvp_voting_progress:
        {
            match_id: '123456789',
            match_players:
            [
                {
                    hero_id: 34,
                    hero_name: 'Tinker',
                    event_points: 0,
                    event_id: 25,
                    vote_count: 2,
                    player_name: 'Eric L',
                    account_id: 1,
                    kills: 7,
                    assists: 3,
                    deaths: 6,
					owns_event: 0
                },
                {
                    hero_id: 29,
                    hero_name: 'Tidehunter',
                    event_points: 8000,
                    event_id: 25,
                    vote_count: 0,
                    player_name: 'Brett S',
                    account_id: 2,
                    kills: 14,
                    assists: 3,
                    deaths: 8,
					owns_event: 1
                },
                {
                    hero_id: 86,
                    hero_name: 'Rubick',
                    event_points: 12000,
                    event_id: 25,
                    vote_count: 3,
                    player_name: 'Kyle',
                    account_id: 3,
                    kills: 2,
                    assists: 12,
                    deaths: 0,
					owns_event: 1
                },
                {
                    hero_id: 102,
                    hero_name: 'Abaddon',
                    event_points: 5000,
                    event_id: 25,
                    vote_count: 0,
                    player_name: 'Sergei',
                    account_id: 4,
                    kills: 21,
                    assists: 12,
                    deaths: 14,
					owns_event: 1
                },
                {
                    hero_id: 59,
                    hero_name: 'Huskar',
                    event_points: 200,
                    event_id: 25,
                    vote_count: 5,
                    player_name: 'Alex',
                    account_id: 5,
                    kills: 8,
                    assists: 4,
                    deaths: 2,
					owns_event: 0
                }
            ]
        }
	};

    TestProgressAnimation(data);
}

var s_TestNumber = 271;

function TestMVP2Screen() {

	var accolades = [];

	var max_accolade = 276;
	while(accolades.length < 3)
	{
		if (g_MVP_Accolade_TypeMap[s_TestNumber] != undefined)
		{
			accolades.push(s_TestNumber);
		}

		s_TestNumber = (s_TestNumber + 1) % max_accolade;
	}

	var data =
    {
		mvp2:
		{
			mvps: [
				{
					slot: 3,
					accountid: 174054,
					guildid: 4,
					heroname: 'npc_dota_hero_naga_siren', // just for display
					// Find hero id in game\dota\scripts\npc\npc_heroes.txt
					overrideheroid: 89,
					// Find econ id in game\dota\scripts\items\items_game.txt
					overrideeconid: 21136,
					was_dire: false,
					accolades: [
						//{ type: accolades[0], detail_value: 113 },
						//{ type: accolades[1], detail_value: 4 },
						//{ type: accolades[2], detail_value: 13 }
						{ type: 11, detail_value: 1000 },
						{ type: 2, detail_value: 0 },
						{ type: 264, detail_value: 23 }
					]
				},
				{
					slot: 1,
					accountid: 85501829,
					guildid: 18,
					heroname: 'npc_dota_hero_windrunner',
					overrideheroid: 21,
					was_dire: false,
					accolades: [
						{ type: 3, detail_value: 11 }
						]
				},
				{
					slot: 2,
                    accountid: 85501006,
					guildid: 4,
					was_dire: true,
					heroname: 'npc_dota_hero_axe',
					overrideheroid: 2,
					accolades: [
						{ type: 18, detail_value: 1 }
						]
				}
            ]
        }
	};

	TestProgressAnimation( data );
}

function TestAnimatePlayerMatchSurvey()
{
	var data =
	{
		match_id: '0',
		player_match_survey_progress: {}
	}

	TestProgressAnimation( data );
}

