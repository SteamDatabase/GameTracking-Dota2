
gStats = {
	"m_LastHitCount" : 0, 
	"m_CurrentLastHitStreakCount": 0,
	"m_HighestLastHitStreakCount": 0,
	"m_CreepsOutOfZoneCount" : 0,
	"m_DenyCount": 0,
	"m_Score": 0,
	"m_nMeleeCreepsKilled": 0,
	"m_nMeleeCreepsDenied": 0,
	"m_nRangedCreepsKilled": 0,
	"m_nRangedCreepsDenied": 0
};

function HideSplashScreen()
{
	$( "#splash_screen_container" ).SetHasClass( "VisibilityCollapsed", true );
}

function PlayFirstRoundButtonPressed()
{
	if ( !gGameInfo.m_bHeroSpawned )
		return

	HideSplashScreen();
	$( "#ControlPanel" ).ToggleClass( "Minimized" );
	$.DispatchEvent('FireCustomGameEvent_Str', 'RoundStartButtonPressed', 'first_round' );
}

function PlayAgainButtonPressed()
{
	$( "#ControlPanel" ).ToggleClass( "Minimized" );
	$('#RoundEndPanel').ToggleClass('Visible');
	$.DispatchEvent('FireCustomGameEvent_Str', 'RoundStartButtonPressed', '' );
}

function RoundEndNewHeroButtonPressed()
{
	$( "#ControlPanel" ).ToggleClass( "Minimized" );
	$('#RoundEndPanel').ToggleClass('Visible');
	ToggleHeroPicker();
}

function OnRoundEnded( roundEndData )
{
	                         

	$( "#RoundEndPanel" ).SetHasClass( "Visible", true );
	$( "#ControlPanel" ).ToggleClass( "Minimized" );
	                                 
	                                   
	                                            

	return true;
}

function ToggleHeroPicker()
{
	$('#ControlPanel').ToggleClass('HeroPickerVisible');
}

function SwitchToNewHero( nHeroID )
{
	$('#ControlPanel').RemoveClass('HeroPickerVisible');
	$.DispatchEvent('FireCustomGameEvent_Str', 'SwitchToNewHero', String(nHeroID));
}

function HideModeStart()
{
	                             

	$( "#ModeStartPanel" ).SetHasClass( "Visible", false );
}

function SetText(name, value)
{
	var element = $(name);

	if(element == null)
		return;

	element.text = value;
}

function UpdateScores()
{
	                            

	SetText('#Score', "" + gStats['m_Score']);
	SetText('#TopLastHitStreak', gStats["m_HighestLastHitStreakCount"]);
	SetText('#CreepsLastHit', gStats["m_LastHitCount"]);
	SetText('#CreepsDenied', gStats["m_DenyCount"]);
	SetText('#TotalLastHitOrDenyPct', parseInt( gStats[ "m_TotalLastHitOrDenyPct" ] * 100 ) + "%" );
	SetText('#MeleeCreepsKilled', gStats["m_nMeleeCreepsKilled"]);
	SetText('#MeleeCreepsDenied', gStats["m_nMeleeCreepsDenied"]);
	SetText('#RangedCreepsKilled', gStats["m_nRangedCreepsKilled"]);
	SetText('#RangedCreepsDenied', gStats["m_nRangedCreepsDenied"]);
	SetText('#GoldFromMeleeCreeps', gStats["m_nGoldFromMeleeCreeps"]);
	SetText('#GoldFromRangedCreeps', gStats["m_nGoldFromRangedCreeps"]);
	                                                                

	                                            
	var nScore = gStats['m_Score'];

	var nBronze = gGameInfo.m_nBronzeScoreReq;
	var nSilver = gGameInfo.m_nSilverScoreReq;
	var nGold = gGameInfo.m_nGoldScoreReq;
	var nDiamond = gGameInfo.m_nDiamondScoreReq;

	if ( nScore < nBronze )
	{
		$( "#TierAchieved" ).text = $.Localize( "#Tier_None" );
		$( "#TierAchieved" ).SwitchClass( "tier_slot", "TierNone" );
	}
	else if ( nScore >= nBronze && nScore < nSilver)
	{
		$( "#TierAchieved" ).text = $.Localize( "#Tier_Bronze" );
		$( "#TierAchieved" ).SwitchClass( "tier_slot", "TierBronze" );
	}
	else if ( nScore >= nSilver && nScore < nGold )
	{
		$( "#TierAchieved" ).text = $.Localize( "#Tier_Silver" );
		$( "#TierAchieved" ).SwitchClass( "tier_slot", "TierSilver" );
	}
	else if ( nScore >= nGold && nScore < nDiamond )
	{
		$( "#TierAchieved" ).text = $.Localize( "#Tier_Gold" );
		$( "#TierAchieved" ).SwitchClass( "tier_slot", "TierGold" );
	}
	else if ( nScore >= nDiamond )
	{
		$( "#TierAchieved" ).text = $.Localize( "#Tier_Diamond" );
		$( "#TierAchieved" ).SwitchClass( "tier_slot", "TierDiamond" );
	}

}

function OnLastHitTrainerStatsUpdated( tableName, key, data )
{
	                              
	gStats = data;

	UpdateScores();
}

function OnLastHitTrainerGameInfoUpdated( tableName, key, data )
{
	                                                      
	gGameInfo = data;

	if ( gGameInfo.m_bHeroSpawned )
	{
		$( "#splash_screen_contents" ).SetHasClass( "VisibilityTransparent", false )
	}
}

(function()
{
	                                                    

	$( "#ControlPanel" ).ToggleClass( "Minimized" );

	GameEvents.Subscribe( "round_ended", OnRoundEnded );

	CustomNetTables.SubscribeNetTableListener("last_hit_trainer_stats", OnLastHitTrainerStatsUpdated);
	CustomNetTables.SubscribeNetTableListener("last_hit_trainer_gameinfo", OnLastHitTrainerGameInfoUpdated);

	$.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#ControlPanel'), SwitchToNewHero );

	                                                        
	                                   
})();

  
           
 
	                                                   

	                                                

	                                                                 
     
  
