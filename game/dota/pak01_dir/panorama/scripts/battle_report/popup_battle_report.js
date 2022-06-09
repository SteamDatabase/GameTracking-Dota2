
// Called from C++
function AnimateIntro()
{
    let seq = new RunSequentialActions();
    let popup = $.GetContextPanel();
    seq.actions.push( new AddClassAction( popup, 'IntroPlaying' ) );
    seq.actions.push( new PlaySoundEffectAction( "BattleReport.IntroStinger" ) );
    seq.actions.push( new WaitAction( 1.0 ) );
    let movieTrack = new RunSequentialActions();
    movieTrack.actions.push( new AddClassAction( popup, 'ShowLogoMovie' ) );
    movieTrack.actions.push( new PlayMovieAction( $( '#LogoMovie' ) ) );
    let uiTrack = new RunSequentialActions();
    uiTrack.actions.push( new WaitAction( 0.4 ) );
    uiTrack.actions.push( new AddClassAction( popup, 'ShowIntroTitle' ) );
    uiTrack.actions.push( new WaitAction( 0.1 ) );
    uiTrack.actions.push( new AddClassAction( popup, 'ShowIntroDate' ) );
    uiTrack.actions.push( new WaitAction( 2.0 ) );
    uiTrack.actions.push( new PlaySoundEffectAction( "BattleReport.IntroSound" ) );
    let par = new RunParallelActions();
    par.actions.push( movieTrack );
    par.actions.push( uiTrack );
    seq.actions.push( par );
    seq.actions.push( new RemoveClassAction( popup, 'IntroPlaying' ) );
    seq.actions.push( new AddClassAction( popup, 'IntroComplete' ) );
    seq.actions.push( new DispatchEventAction( 'DOTABattleReportSetActiveScreen', 0 ) );
    RunSingleAction( seq );
}