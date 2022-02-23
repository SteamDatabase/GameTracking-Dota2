var g_ActiveAnimationFunction = null;

var RunAnimationIfNotRunning = function ( animationFunction )
{
    if( g_ActiveAnimationFunction != animationFunction )
    {
        g_ActiveAnimationFunction = animationFunction;
        animationFunction();
    }
}

var RunIntroAnimation = function ()
{
    // $.Msg( "RunIntroAnimation" );

    var scenePanel = $( '#BackgroundScene' );

    var seq = new RunSequentialActions();

    seq.actions.push( new WaitForClassAction( scenePanel, 'SceneLoaded' ) );
    seq.actions.push( new FireEntityInputAction( scenePanel, 'primal_beast_frontpage', 'Enable', '' ) );

    RunSingleAction( seq ); 
}

var RunIdleAnimation = function ()
{
    // $.Msg( "RunIdleAnimation" );

    var scenePanel = $( '#BackgroundScene' );

    var seq = new RunSequentialActions();

    seq.actions.push( new WaitForClassAction( scenePanel, 'SceneLoaded' ) );
    seq.actions.push( new FireEntityInputAction( scenePanel, 'primal_beast_frontpage', 'Enable', '' ) );

    RunSingleAction( seq );
}

var RunOutroAnimation = function ()
{
    // $.Msg( "RunOutroAnimation" );

    var scenePanel = $( '#BackgroundScene' );

    var seq = new RunSequentialActions();

    seq.actions.push( new WaitForClassAction( scenePanel, 'SceneLoaded' ) );
    seq.actions.push( new FireEntityInputAction( scenePanel, 'primal_beast_frontpage', 'Disable', '') );

    RunSingleAction( seq );
}

var GetActivePageType = function ()
{
    // todo(ericl): This is a kinda terrible way to do this.
    var dashboard = $.GetContextPanel().FindAncestor( "Dashboard" );
    var pageManager = dashboard.FindChildInLayoutFile( "DashboardPages" );
    for ( var i = 0; i < pageManager.GetChildCount(); ++i )
    {
        var page = pageManager.GetChild( i );
        if ( page.BHasClass( 'PageVisible' ) )
            return page.paneltype;
    }

    return null;
}

var g_bFirstRun = true;

var UpdateAnimation = function()
{
    // $.Msg( "page type = " + GetActivePageType() );

    var bHomePage = ( GetActivePageType() == "DOTAHomePage" );

    $.GetContextPanel().SetHasClass( "OnHomePage", bHomePage );

    if ( !$( '#BackgroundScene' ).BHasClass( "SceneLoaded" ) )
        return;

    if ( bHomePage )
    {
        if ( g_bFirstRun )
        {
            RunAnimationIfNotRunning( RunIntroAnimation );
            g_bFirstRun = false;
        }
        else
        {
            RunAnimationIfNotRunning( RunIdleAnimation );
        }
    }
    else
    {
        RunAnimationIfNotRunning( RunOutroAnimation );
    }
}


$.RegisterForUnhandledEvent( 'PageManagerActivatedPage', function ( pageManager, oldPage, newPage )
{
    // $.Msg( "Page Activated" );
    $.Schedule( 0.0, function () { UpdateAnimation(); } );
} );

$.RegisterEventHandler( 'DOTAScenePanelSceneLoaded', $( '#BackgroundScene' ), function ( scenePanel )
{
    // $.Msg( "Scene Loaded" );
    $.Schedule( 0.0, function () { UpdateAnimation(); } );
} );

$.RegisterEventHandler( 'DOTAScenePanelSceneUnloaded', $( '#BackgroundScene' ), function ( scenePanel )
{
    //$.Msg( "Scene Unloaded" );
    g_ActiveAnimationFunction = null;
} );
