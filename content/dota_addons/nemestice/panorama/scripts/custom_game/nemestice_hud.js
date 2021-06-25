
var strCurrentInstanceMessageClass = "";
var nCurrentInstanceMessagePriority = 0;
var flCurrentInstanceMessageDieTime = -1;
var flRoundStartClearTime = -1;
var flMeteorAnnouncementClearTime = -1;
var flRadiantTowerAnnounceClearTime = -1;
var flDireTowerAnnounceClearTime = -1;
var g_bMinimapIconsSet = false;
var g_bDontShowCheckBox = false;

$.Msg( "spring_hud.js loaded" ); 

SetTimeValue( 0 );
$.GetContextPanel().SetDialogVariableInt( "radiant_kills", 0 );
$.GetContextPanel().SetDialogVariableInt( "dire_kills", 0 );
$.GetContextPanel().SetDialogVariable( "meteor_timer", "0:00" );

function SetHUDVisible( bVisible )
{
    //$.Msg( "^^^Setting HUD visible to " + bVisible );

    var minimapPanel = $.GetContextPanel().FindChildInLayoutFile( "Compass" );
    if ( minimapPanel != null )
    {
        minimapPanel.SetHasClass( "Hidden", !bVisible );
    }

    var topmapPanel = $.GetContextPanel().FindChildInLayoutFile( "TopMap" );
    if ( topmapPanel != null )
    {
        topmapPanel.SetHasClass( "Hidden", !bVisible );
    }

    var hudRootPanel = $.GetContextPanel().FindAncestor( "Hud" );
    if ( hudRootPanel != null )
    {
        //$.Msg( "^^^Found HUD root" );
        hudRootPanel.AddClass( "nemestice" );
        var hudElementsPanel = hudRootPanel.FindChild( "HUDElements" )
        if ( hudElementsPanel != null )
        {
            //$.Msg( "^^^Found HUD Elements" );
            if ( bVisible )
            {
                hudElementsPanel.style.visibility = "visible";
            }
            else
            {
                hudElementsPanel.style.visibility = "collapse";
            }
            
        }
    }
}

function SetLogoVisible( bVisible )
{
    var logoPanel = $.GetContextPanel().FindChildInLayoutFile( "NemesticeLogoIntro" );
    if ( logoPanel != null )
    {
        logoPanel.SetHasClass( "Visible", bVisible );
    }
}

//function SetSlowFade( bOn )
//{
//    var blackOverlayPanel = $.GetContextPanel().FindChildInLayoutFile( "BlackOverlay" );
//    if ( blackOverlayPanel != null )
//    {
//        blackOverlayPanel.SetHasClass( "SlowFade", bOn );
//    }
//}

function OnThink()
{
    $.GetContextPanel().SetHasClass( "IsPaused", Game.IsGamePaused() );

    if ( Game.IsDayTime() )
    {
        $.GetContextPanel().SwitchClass( "TimeOfDay", "DayTime" )
    }
    else
    {
        $.GetContextPanel().SwitchClass( "TimeOfDay", "NightTime" )
    }

    if ( flRoundStartClearTime != -1 && Game.GetDOTATime( false, true ) >= flRoundStartClearTime )
    {
        flRoundStartClearTime = -1;
        $.GetContextPanel().RemoveClass( "ShowGameStart" );
        $.GetContextPanel().RemoveClass( "RoundNameTitleAnimation" );
    }

    if ( flMeteorAnnouncementClearTime != -1 && Game.GetDOTATime( false, true ) >= flMeteorAnnouncementClearTime )
    {
        flMeteorAnnouncementClearTime = -1;
        $.GetContextPanel().RemoveClass( "ShowMeteorAnnouncement" );
        $.GetContextPanel().RemoveClass( "MeteorAnnouncementTitleAnimation" );
    }

    if ( flRadiantTowerAnnounceClearTime != -1 && Game.GetDOTATime( false, true ) >= flRadiantTowerAnnounceClearTime )
    {
        flRadiantTowerAnnounceClearTime = -1;
        var towerAnnouncePanel = $.GetContextPanel().FindChildInLayoutFile( "RadiantSide" );
        if ( towerAnnouncePanel != null )
        {
            towerAnnouncePanel.RemoveClass( "Visible" );    
        }
    }
    
    if ( flDireTowerAnnounceClearTime != -1 && Game.GetDOTATime( false, true ) >= flDireTowerAnnounceClearTime )
    {
        flDireTowerAnnounceClearTime = -1;
        var towerAnnouncePanel = $.GetContextPanel().FindChildInLayoutFile( "DireSide" );
        if ( towerAnnouncePanel != null )
        {
            towerAnnouncePanel.RemoveClass( "Visible" );
        }
    }

    if ( serverValues !== undefined )
    {
        if ( serverValues.GameState !== serverConstants.NEMESTICE_GAMESTATE_POSTLOAD_PHASE )
        {
            $.GetContextPanel().SetHasClass( "FadeToBlack", serverValues.GameState === serverConstants.NEMESTICE_GAMESTATE_PREGAME );
        }
        if ( serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_PREGAME )
        {
            $.GetContextPanel().SwitchClass( "GameState", "NEMESTICE_GAMESTATE_PREGAME" );
            $.GetContextPanel().SetDialogVariable("round_end_timer_prefix", "Spawning Heroes");

            SetHUDVisible( false );
        }
        else if ( serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_GAMEOVER )
        {
            ClearInstanceMessage();
            $.GetContextPanel().SwitchClass( "GameState", "NEMESTICE_GAMESTATE_GAMEOVER" );
            $.GetContextPanel().SetDialogVariable("round_end_timer_prefix", "Game Over");
        }
        else if ( serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_POSTLOAD_PHASE )
        {
            if ( !$.GetContextPanel().BHasClass( "NEMESTICE_GAMESTATE_POSTLOAD_PHASE" ) )
            {
                $.GetContextPanel().SetHasClass( "FadeToBlack", false );
            }            
            ClearInstanceMessage();
            $.GetContextPanel().SwitchClass( "GameState", "NEMESTICE_GAMESTATE_POSTLOAD_PHASE" );
            $.GetContextPanel().SetDialogVariable("round_end_timer_prefix", "Round Interstitial Time");
            var nSecondsRemaining = serverValues.TimePhaseEnds - Game.GetDOTATime( false, true);
            SetTimeValue( nSecondsRemaining );
        }
        else if ( serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_PREP_TIME )
        {
            SetHUDVisible( true );
            ClearInstanceMessage();
            $.GetContextPanel().SwitchClass( "GameState", "NEMESTICE_GAMESTATE_PREP_TIME" );
            $.GetContextPanel().SetDialogVariable( "round_end_timer_prefix", "Prep Time" );
            var nSecondsRemaining = serverValues.TimePhaseEnds - Game.GetDOTATime( false, true );
            SetTimeValue( nSecondsRemaining );

            if ( !g_bMinimapIconsSet )
            {
                var nLocalTeam = Players.GetTeam( Players.GetLocalPlayer() ) === DOTATeam_t.DOTA_TEAM_BADGUYS ? DOTATeam_t.DOTA_TEAM_BADGUYS : DOTATeam_t.DOTA_TEAM_GOODGUYS; // Catches spectators and such
                var buildingEntities = Entities.GetAllBuildingEntities();
                for ( var i = 0; i < Object.keys( buildingEntities ).length; i++ )
                {
                    var buildingEntIndex = buildingEntities[ i ];
                    if ( buildingEntIndex == -1 )
                        continue;

                    if ( !Entities.IsTower( buildingEntIndex ) )
                        continue;

                    if ( nLocalTeam == Entities.GetTeamNumber( buildingEntIndex ) )
                    {
                        Entities.SetMinimapIcon( buildingEntIndex, "minimap_spring2021_radiant_pip" );
                    }
                    else
                    {
                        Entities.SetMinimapIcon( buildingEntIndex, "minimap_spring2021_dire_pip" );
                    }
                }

                g_bMinimapIconsSet = true;
            }
        }
        else if ( serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_IN_PROGRESS || serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_SUDDEN_DEATH )
        {
            TryExpireInstanceMessage();
            $.GetContextPanel().SwitchClass( "GameState", "NEMESTICE_GAMESTATE_IN_PROGRESS" );
            $.GetContextPanel().SetDialogVariable( "round_end_timer_prefix", "Round Time" );
            if ( serverValues.GameState == serverConstants.NEMESTICE_GAMESTATE_SUDDEN_DEATH )
            {
                $.GetContextPanel().SetDialogVariable( "timevalue", "----" );
                $.GetContextPanel().SetHasClass( "Last30Seconds", true );
                $.GetContextPanel().SetHasClass( "Last10Seconds", true );
            }
            else
            {
                var flDotaTime = Game.GetDOTATime( false, true );
                var flSecondsRemaining = serverValues.TimePhaseEnds - flDotaTime;
                SetTimeValue( serverValues.TimePlayedCached + flDotaTime - serverValues.TimePhaseStarted );                
            }
        }
    } 

    $.GetContextPanel().SetDialogVariableInt( "radiant_kills", Game.GetTeamDetails( DOTATeam_t.DOTA_TEAM_GOODGUYS ).team_score );
    $.GetContextPanel().SetDialogVariableInt( "dire_kills", Game.GetTeamDetails( DOTATeam_t.DOTA_TEAM_BADGUYS ).team_score );
    UpdateTowerUnderAttack();
    UpdateCompass();

    $.Schedule( 0.1, OnThink )
}
$.Schedule( 0.0, OnThink )

function OnPlayDetailsDontShowAgain()
{
    $.Msg( "OnPlayDetailsDontShowAgain()" )
    g_bDontShowCheckBox = !g_bDontShowCheckBox;
    Game.NemesticeSetShowGameInfo( !g_bDontShowCheckBox );

    var dontShowAgainPanel = $.GetContextPanel().FindChildInLayoutFile( "DontShowAgainButton" );
    if ( dontShowAgainPanel != null )
    {
        dontShowAgainPanel.SetHasClass( "CheckboxActive", g_bDontShowCheckBox );
    }    
}

function SetupHowToPlay()
{
    $.Msg( "^^^SetupHowToPlay()" )

    var bShowGameInfo = Game.NemesticeShouldShowGameInfo()
    if ( bShowGameInfo == false )
    {
        $.Msg( "^^^Show Game Info is false - skipping this whole thing!" )
        return;
    }

    $( "#NemesticePlayDetails" ).SetHasClass( "Visible", true );
    Game.EmitSound( "ui_find_match_slide_in" );
}

function OnGameInfoDismissed()
{
    $( "#NemesticePlayDetails" ).SetHasClass( "Visible", false );
    Game.EmitSound( "ui_find_match_slide_out" );
}

function OnExecuteAbility( data )
{
    var nAbilityEntIndex = data[ "ability_ent_index" ];
    var nCasterEntIndex = data[ "caster_ent_index" ];
    Abilities.ExecuteAbility( nAbilityEntIndex, nCasterEntIndex, false );
}
GameEvents.Subscribe( "player_execute_ability", OnExecuteAbility );

function SetTimeValue( flSecondsRemaining )
{
    if ( flSecondsRemaining < 0 )
    {
        flSecondsRemaining = 0;
    }
    var nMinutesRemaining = Math.floor( flSecondsRemaining / 60 );
    var nSecondsRemaining = Math.floor( flSecondsRemaining - nMinutesRemaining * 60) ;
    var resultString = nMinutesRemaining.toString() + ":";
    if ( nSecondsRemaining < 10 )
    {
        resultString = resultString + "0";
    }
    resultString = resultString + nSecondsRemaining.toString();
    $.GetContextPanel().SetDialogVariable( "timevalue", resultString );
    $.GetContextPanel().SetHasClass( "Last30Seconds", ( nMinutesRemaining == 0 ) && ( nSecondsRemaining <= 30 ) );
    $.GetContextPanel().SetHasClass( "Last10Seconds", ( nMinutesRemaining == 0 ) && ( nSecondsRemaining <= 10 ) );
}

function OnGameEventGameStart( e )
{
    $.GetContextPanel().AddClass( "RoundNameTitleAnimation" );

    $.GetContextPanel().AddClass( "ShowGameStart" );
    flRoundStartClearTime = Game.GetDOTATime( false, true ) + 4.0;
}
GameEvents.Subscribe( "game_start", OnGameEventGameStart )

function OnGameEventMeteorAnnounce( e )
{
    $.GetContextPanel().AddClass( "MeteorAnnouncementTitleAnimation" );
    $.GetContextPanel().AddClass( "ShowMeteorAnnouncement" );

    flMeteorAnnouncementClearTime = Game.GetDOTATime( false, true ) + 4.0;
}
GameEvents.Subscribe( "meteor_announce", OnGameEventMeteorAnnounce )

function OnGameEventTowerDestroyed( e )
{
    var towerAnnouncePanel
    //$.Msg( "TOWER DESTROYED FOR " + e.team_id )
    if ( e.team_id == DOTATeam_t.DOTA_TEAM_GOODGUYS )
    {
        //$.Msg( "TOWERS DESTROYED FOR GOOD GUYS" )
        towerAnnouncePanel = $.GetContextPanel().FindChildInLayoutFile( "RadiantSide" );
        flRadiantTowerAnnounceClearTime = Game.GetDOTATime( false, true ) + 5.0;
    }
    else
    {
        //$.Msg( "TOWERS DESTROYED FOR BAD GUYS" )
        towerAnnouncePanel = $.GetContextPanel().FindChildInLayoutFile( "DireSide" );
        flDireTowerAnnounceClearTime = Game.GetDOTATime( false, true ) + 5.0;
    }

    if ( towerAnnouncePanel != null )
    {
        switch ( e.towers_remaining )
        {
            case 3:     // kobolds
                //$.Msg( "ADDING KOBOLDS CLASS" )
                towerAnnouncePanel.SwitchClass( "ShowCreepType", "ShowKobolds" )
                break;
            case 2:     // priests
                //$.Msg( "ADDING PRIESTS CLASS" )
                towerAnnouncePanel.SwitchClass( "ShowCreepType", "ShowPriests" )
                break;
            case 1:     // hellbears
                //$.Msg( "ADDING HELLBEARS CLASS" )
                towerAnnouncePanel.SwitchClass( "ShowCreepType", "ShowHellbears" )
                break;
            default:
                break;
        }

        towerAnnouncePanel.AddClass( "Visible" );
        towerAnnouncePanel.SetDialogVariableInt( "towers_remaining", e.towers_remaining );
        if ( e.towers_remaining == 1 )
        {
            towerAnnouncePanel.SwitchClass( "Plurality", "Singular" )
        }
        else
        {
            towerAnnouncePanel.SwitchClass( "Plurality", "Plural" )
        }        
    }
}
GameEvents.Subscribe( "tower_destroyed", OnGameEventTowerDestroyed )

function OnGameEventStartIntroCinematic( e )
{
    if ( e.skip_cinematic == 1 )
    {        
        $.Schedule( 0.1, function() { SetHUDVisible( true ); } );
        $.Schedule( 1.0, SetupHowToPlay );
    }
    else
    {
        Game.EmitSound( "Nemestice.Opening.Underscore" );

        var fCamDuration = Game.PlayDataDrivenCamera( "camera/cameras/nemestice_intro.txt" );
        $.Msg( "^^^Playing data driven camera with duration = " + fCamDuration );
        fCamDuration = fCamDuration + 3;    // add some additional time with the static camera
        $.Schedule( fCamDuration - 5.5, function() { SetLogoVisible( true ); } );
        $.Schedule( fCamDuration - 0, function() { SetLogoVisible( false ); } );
        $.Schedule( fCamDuration - 0.6, function() { $.Msg("FADING TO BLACK!!!"); $.GetContextPanel().AddClass( "FadeToBlack" ); } );
        $.Schedule( fCamDuration, CutToDefaultCamera );
        $.Schedule( fCamDuration + 0.1, function() { $.Msg("COMING BACK!!!");  $.GetContextPanel().RemoveClass( "FadeToBlack" ); } );
        $.Schedule( fCamDuration + 0.1, function() { SetHUDVisible( true ); } );

        $.Schedule( fCamDuration + 1.0, SetupHowToPlay );
    }
}
GameEvents.Subscribe( "start_intro_cinematic", OnGameEventStartIntroCinematic )

function CutToDefaultCamera()
{
    Game.CutToDefaultCamera()
}

function TryUpdateInstanceMessage( flDuration, nPriority, strNewClass )
{
    if ( nPriority < nCurrentInstanceMessagePriority )
        return false;

    if ( strCurrentInstanceMessageClass != "" )
    {
        $.GetContextPanel().RemoveClass( strCurrentInstanceMessageClass );
    }

    strCurrentInstanceMessageClass = strNewClass;
    if ( strNewClass == "" )
    {
        nCurrentInstanceMessagePriority = 0;
        flCurrentInstanceMessageDieTime = -1.0;
    }
    else
    {
        nCurrentInstanceMessagePriority = nPriority;
        $.GetContextPanel().AddClass( strNewClass );

        if ( flDuration > 0 )
        {
            flCurrentInstanceMessageDieTime = flDuration + Game.GetDOTATime( false, true );
        }
        else
        {
            flCurrentInstanceMessageDieTime = -1.0;
        }
    }

    return true;
}

function TryExpireInstanceMessage()
{
    if ( flCurrentInstanceMessageDieTime > 0 && flCurrentInstanceMessageDieTime <= Game.GetDOTATime( false, true ) )
    {
        ClearInstanceMessage();
    }
}

function ClearInstanceMessage()
{
    if ( flCurrentInstanceMessageDieTime > 0 )
    {
        TryUpdateInstanceMessage( -1.0, 99999, "" );
    }
}

function OnGameEventOvertime( e )
{
    $.GetContextPanel().SetDialogVariableInt( "extra_time", e.extra_time );
    TryUpdateInstanceMessage( 2.0, 60, "ShowOvertimePopup" );
}
GameEvents.Subscribe( "start_overtime", OnGameEventOvertime )

function OnGameEventSuddenDeath( e )
{
    TryUpdateInstanceMessage( 2.0, 61, "ShowSuddenDeathPopup" );
}
GameEvents.Subscribe( "start_sudden_death", OnGameEventSuddenDeath )

function OnGameEventTimeLeft( e )
{
    $.GetContextPanel().SwitchClass( "timeLeft", "timeLeft" + e.time_left );
    var flDuration = 1.0;
    if ( e.time_left > 5 )
    {
        flDuration = 2.0;
    }
    TryUpdateInstanceMessage( flDuration, 1, "ShowTimeLeftPopup" );
}
GameEvents.Subscribe( "time_left", OnGameEventTimeLeft )

function towerIsAlive( towerName )
{
    var team = Entities.GetTeamNumber( mapStateTowers[ towerName ].entindex );
    return team == DOTATeam_t.DOTA_TEAM_GOODGUYS || team == DOTATeam_t.DOTA_TEAM_BADGUYS;
}

var TOP_MAP_GRAPH_PADDING = 14;
var TOP_MAP_GRAPH_WIDTH = 135;
var TOP_MAP_GRAPH_HEIGHT = 117;
var previousOutpostCount = 0;
var graphOutposts = null;// [{ name, panels, attackPanel }]
function DrawTopMap()
{
    var player = Players.GetLocalPlayer();
    var playerTeam = Players.GetTeam( player ) === DOTATeam_t.DOTA_TEAM_BADGUYS ? DOTATeam_t.DOTA_TEAM_BADGUYS : DOTATeam_t.DOTA_TEAM_GOODGUYS; // Catches spectators and such

    var graphPanel = $.GetContextPanel().FindChildInLayoutFile( "TopMapGraph" );
    if ( !graphPanel )
    {
        return;
    }

    var outpostCount = Object.keys( mapStateTowers ).filter( towerIsAlive ).length;
    if ( outpostCount === previousOutpostCount )
    {
        return;
    }

    graphPanel.RemoveAndDeleteChildren();
    outpostCount = previousOutpostCount;

    var radiantCount = 0;
    var direCount = 0;
    objectForEach( mapStateTowers, ( name, tower ) =>
    {
        var team = Entities.GetTeamNumber( tower.entindex );
        if ( team === DOTATeam_t.DOTA_TEAM_GOODGUYS ) radiantCount++;
        if ( team === DOTATeam_t.DOTA_TEAM_BADGUYS ) direCount++;
    });

    var positionByName = calculateTowerPositions( TOP_MAP_GRAPH_PADDING, TOP_MAP_GRAPH_WIDTH - TOP_MAP_GRAPH_PADDING, TOP_MAP_GRAPH_PADDING, TOP_MAP_GRAPH_HEIGHT - TOP_MAP_GRAPH_PADDING );
    if ( !positionByName )
    {
        $.Schedule( 0.5, DrawTopMap );
        return;
    }

    objectForEach( mapStateLanes, ( name, lane ) =>
    {
        createLane( graphPanel,
            positionByName[lane.tower1].x,
            positionByName[lane.tower1].y,
            positionByName[lane.tower2].x,
            positionByName[lane.tower2].y
        );
    } );

    graphOutposts = [];
    objectForEach( mapStateTowers, ( name, tower ) =>
    {
        if ( towerIsAlive( name ) )
        {
            var team = Entities.GetTeamNumber( tower.entindex );
            var alliedCount = team === DOTATeam_t.DOTA_TEAM_GOODGUYS ? radiantCount : direCount;
            var rings = 4 - alliedCount;
            var allyClass = team === playerTeam ? "Ally" : "Enemy";

            graphOutposts.push(
                createOutpost(
                    graphPanel,
                    positionByName[name].x,
                    positionByName[name].y,
                    name,
                    rings,
                    allyClass
                )
            );
        }
    } );
}

$.Schedule( 0, DrawTopMap );

function OnMapStateChanged() // notification of change to mapStateTowers from nemestice_shared.js
{
    DrawTopMap();
}

function calculateTowerPositions( minX, maxX, minY, maxY )
{
    var towerNames = Object.keys( mapStateTowers );

    var bFailed = false;
    var positions = towerNames.map( n => {
        var p = Entities.GetAbsOrigin( mapStateTowers[n].entindex );
        if (!p)
        {
            bFailed = true;
            return null;
        }
        else
        {
            return { x: p[0], y: -p[1] };
        }
    } );
    if ( bFailed )
    {
        return null;
    }

    positions = remapPointSet( positions, minX, maxX, minY, maxY );
    
    var positionByName = {};
    towerNames.forEach( ( name, index ) => positionByName[name] = positions[index] );

    return positionByName;
}

var LANE_WIDTH_PX = 5;
function createLane( parentPanel, x1, y1, x2, y2 )
{
    var dx = x2 - x1;
    var dy = y2 - y1;
    var angle = Math.atan2( dy, dx ) * 180 / Math.PI;
    var length = Math.sqrt( dy * dy + dx * dx )

    var panel = $.CreatePanel( "Panel", parentPanel, "" );
    panel.AddClass( "Lane" );
    panel.SetPositionInPixels( x1, y1 - ( LANE_WIDTH_PX / 2 ), 0 );
    panel.style.transform = `scaleX(${length / 100}) rotateZ(${angle}deg);`;

    return panel;
}

function createOutpost( parentPanel, x, y, name, rings, allyClass )
{
    var outpostPanel = $.CreatePanel( "Panel", parentPanel, "" );
    outpostPanel.AddClass( "Outpost" );
    outpostPanel.AddClass( allyClass );
    outpostPanel.SetPositionInPixels( x, y, 0 );

    for( var i = 1; i <= rings; i++ )
    {
        var ringPanel = $.CreatePanel( "Panel", outpostPanel, "" );
        ringPanel.AddClass( `OutpostRing${i}` );
    }
    
    var attackPanel = $.CreatePanel( "Panel", outpostPanel, "" );
    attackPanel.AddClass( `OutpostAttack` );

    return { name: name, panel: outpostPanel };
}

function remapPointSet( points, minX, maxX, minY, maxY )
{
    var minPX, maxPX = minPX = points[0].x;
    var minPY, maxPY = minPY = points[0].y;
    points.forEach( p => {
        if (p.x < minPX) minPX = p.x;
        else if (p.x > maxPX) maxPX = p.x;
        if (p.y < minPY) minPY = p.y;
        else if (p.y > maxPY) maxPY = p.y;
    });

    var xScale = ( maxX - minX ) / ( maxPX - minPX );
    var yScale = ( maxY - minY ) / ( maxPY - minPY );
    var scale, xOffset, yOffset = 0;
    if ( xScale < yScale )
    {
        scale = xScale;
        xOffset = minX;
        yOffset = minY + ( ( maxY - minY ) - ( maxPY - minPY ) * scale ) / 2;
    }
    else
    {
        scale = yScale;
        xOffset = minX + ( ( maxX - minX ) - ( maxPX - minPX ) * scale ) / 2;
        yOffset = minY;
    }

    return points.map( p => ({
        x: ( p.x - minPX ) * scale + xOffset,
        y: ( p.y - minPY ) * scale + yOffset
    }) );
}

function UpdateTowerUnderAttack()
{
    if ( graphOutposts != null )
    {
        graphOutposts.forEach( outpost => {
            outpost.panel.SetHasClass( "UnderAttack", !!serverValues.TowersUnderAttack[ outpost.name ] || false );
        } );
    }
}

var ARROW_LOST_SPEED = 10; // degrees per second
var ARROW_FOUND_SPEED = 90; // degrees per second
var ARROW_NEAR_SPEED = 200; // degrees per second
var ARROW_NEAR_DISTANCE = 400;
var flCurrentArrowDeg = 0.0;
var flTargetArrowDeg = 0.0;
var flLastArrowUpdateTime = 0;
var flNextMeteorCrashTime = 0;
var bMeteorIncoming = false
function UpdateCompass()
{
    if ( Game.IsGamePaused() )
    {
        return;
    }

    var topMapPanel = $.GetContextPanel().FindChildInLayoutFile( "TopMap" );
    if ( topMapPanel != null )
    {
        if ( topMapPanel.BHasClass( "Hidden" ) )
        {
            return;
        }
    }


    var compassPanel = $.GetContextPanel().FindChildInLayoutFile( "MeteorCompass" );
    var cooldownOverlayPanel = $.GetContextPanel().FindChildInLayoutFile( "CompassCooldownOverlay" );
    var arrowPanel = $.GetContextPanel().FindChildInLayoutFile( "CompassArrow" );
    if ( compassPanel == null || cooldownOverlayPanel == null || arrowPanel == null )
    {
        return;
    }

    compassPanel.SetHasClass( "MeteorWaiting", serverValues.MeteorState === serverConstants.NEMESTICE_METEOR_STATE_WAITING );
    compassPanel.SetHasClass( "MeteorWarning", serverValues.MeteorState === serverConstants.NEMESTICE_METEOR_STATE_WARNING );
    compassPanel.SetHasClass( "MeteorMarking", serverValues.MeteorState === serverConstants.NEMESTICE_METEOR_STATE_MARKING );
    compassPanel.SetHasClass( "MeteorFalling", serverValues.MeteorState === serverConstants.NEMESTICE_METEOR_STATE_FALLING );

    var isMeteorAlive = serverValues.MeteorEntindex && Entities.IsAlive( serverValues.MeteorEntindex );
    compassPanel.SetHasClass( "MeteorAlive", !!isMeteorAlive );

    if ( serverValues.MeteorState === serverConstants.NEMESTICE_METEOR_STATE_WAITING )
    {
        // serverValues.NextMeteorCrashTime changes to the next NEXT meteor right when the warnings start
        // but we want to keep showing cooldown for just the next meteor
        flNextMeteorCrashTime = serverValues.NextMeteorCrashTime; 
    }

    var time = Game.GetDOTATime( false, true );
    var timeUntilMeteor = Math.max( flNextMeteorCrashTime - time, 0 );
    var minutesRemaining = Math.floor( timeUntilMeteor / 60 );
    var secondsRemaining = Math.floor( timeUntilMeteor - minutesRemaining * 60 );
    compassPanel.SetDialogVariable( "meteor_timer", `${minutesRemaining}:${secondsRemaining.toString().padStart(2, "0")}` );

    var meteorPercent = timeUntilMeteor / serverConstants.NEMESTICE_LARGE_METEOR_CRASH_SITE_INTERVAL
    cooldownOverlayPanel.style.clip = `radial( 50% 50%, 0deg, ${ -360 * meteorPercent }deg )`;

    if ( timeUntilMeteor > 0 && timeUntilMeteor < 10 )
    {
        if ( !bMeteorIncoming )
        {

            bMeteorIncoming = true;
            arrowPanel.style.transform = null;
            compassPanel.SetHasClass( "MeteorIncoming", true );
            Game.EmitSound( "Nemestice.CompassPulse" );
        }

        return;
    }
    else
    {
        if ( bMeteorIncoming )
        {
            bMeteorIncoming = false;
            compassPanel.SetHasClass( "MeteorIncoming", false );
        }
    }
    
    var deltaTime = time - flLastArrowUpdateTime;
    var deltaDeg = deltaTime * ARROW_LOST_SPEED;
    if ( isMeteorAlive )
    {
        var camPosition = GameUI.GetCameraLookAtPosition();
        var meteorPosition = Entities.GetAbsOrigin( serverValues.MeteorEntindex );

        if ( Game.Length2D( camPosition, meteorPosition ) < ARROW_NEAR_DISTANCE )
        {
            var deltaDeg = deltaTime * ARROW_NEAR_SPEED
            flTargetArrowDeg = ( Math.random() * 360 ) - 180;
        }
        else
        {
            var deltaDeg = deltaTime * ARROW_FOUND_SPEED
            flTargetArrowDeg = -angle2d( camPosition, meteorPosition ) + 90;
            if ( Math.abs( ( flTargetArrowDeg + 360 ) - flCurrentArrowDeg ) < Math.abs( flTargetArrowDeg - flCurrentArrowDeg ) )
            {
                flTargetArrowDeg += 360;
            } 
            else if ( Math.abs( ( flTargetArrowDeg - 360 ) - flCurrentArrowDeg ) < Math.abs( flTargetArrowDeg - flCurrentArrowDeg ) )
            {
                flTargetArrowDeg -= 360;
            }
        }
    }
    else if ( flCurrentArrowDeg === flTargetArrowDeg )
    {
        flTargetArrowDeg = ( Math.random() * 360 ) - 180;
    }

    if ( flTargetArrowDeg < flCurrentArrowDeg )
    {
        flCurrentArrowDeg = Math.max( flCurrentArrowDeg - deltaDeg, flTargetArrowDeg );
    }
    else
    {
        flCurrentArrowDeg = Math.min( flCurrentArrowDeg + deltaDeg, flTargetArrowDeg );
    }
    arrowPanel.style.transform = `rotateZ(${flCurrentArrowDeg}deg);`;
    flLastArrowUpdateTime = time;
}

function OnCourierSpawned( data )
{
    $.Msg( "************************************* Courier Spawned ****************************" );
}
