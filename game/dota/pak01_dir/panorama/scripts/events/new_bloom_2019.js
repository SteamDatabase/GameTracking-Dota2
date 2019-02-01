var pigIdle;
var pigAnimating;
var clickNumber;

    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#Model'),
        function ()
        {
            $.Msg("pig loaded");
            pigAnimating = false;
            clickNumber = 0;
            $.FireEntityInput('pig', 'SetAnimation', 'pb_idle');
        });



    //$('#Model').FireEntityInput('pig', 'SetAnimation', 'pb_idle');
    //    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#ModelBackground'), function () { $.DispatchEvent('PlaySoundEffect', 'grimstroke_takeover_stinger'); });
    //NOT WORKING
    //$.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#Model').FireEntityInput('smoke_particle', 'Start', '1'));
    //$.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#Model').FireEntityInput('smoke_timeremap', 'SetAnimation', 'time_remap_smoke_side'));


var pigClick = function ()
{
    clickNumber++;
    $.Msg("click");
    if (clickNumber > 10 && !pigAnimating)
    {
        $.Msg("pigClick dead");
        $('#Model').FireEntityInput('pig_death', 'Start', '1');
        $('#Model').FireEntityInput('pig', 'TurnOff', '');
        return;
    }

    if (clickNumber < 10)
    {
        $.Msg("pigClick pressed");
        

        $.Msg("pigNumber =" + clickNumber);

        if (pigAnimating)
            return;

        $('#Model').FireEntityInput('pig', 'SetAnimation', 'pb_spin_tree');

        pigAnimating = true;

        $.Schedule(2.0, function () {
            $.Msg("pigClick idle trigger");
            $('#Model').FireEntityInput('pig', 'SetAnimation', 'pb_idle');
            pigAnimating = false;

            //adds one to a var clickNumber++
            //if reaches X baloon dies and it does not trigger the function anymore
            //not trigger if animation is happening
        });
    }



}