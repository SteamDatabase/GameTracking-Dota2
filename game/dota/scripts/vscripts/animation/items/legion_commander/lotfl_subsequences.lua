--============ Copyright (c) Valve Corporation, All rights reserved. ==========
require "animationsystem.sequences"
DoIncludeScript( "animation/sequence_functions/sequence_functions", getfenv(1) )

--
-- define weight lists
--
model:CreateWeightlist(
	"cape",
	{
		{ "Root0_JNT", 0 },
		{ "Spine3_JNT", 0 },
		{ "banner_0_root", 1 }
	}
)

model:CreateWeightlist(
	"no_cape",
	{
		{ "Root0_JNT", 1 },
		{ "Spine3_JNT", 1 },
		{ "banner_0_root", 0 }
	}
)

-- apply weightlist to item-specific animations so they can be overlaid 
-- to other sequences
model:CreateSequence( 
    {
        name = "@pta_cape_full_overlay",
        looping = true,
        hidden = true,
        sequences = {
            { "@lotfl_pta_overlay" }
        },
        weightlist = "cape"

    }
)
model:CreateSequence( 
    {
        name = "@normal_cape_full_overlay",
        looping = true,
        hidden = true,
        sequences = {
            { "@lotfl_normal_overlay" }
        },
        weightlist = "cape"

    }
)

-- construct subsequences of the overlay animations so they match the start-/end-
-- of the target sequences themselves (must match otherwise the frame ranges
-- are interpolated)

-- (idle)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_idle_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 44
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_idle_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 44
    }
)

-- (press the attack)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_press_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 34
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_press_layer", 
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 34
    }
)

-- (attack)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_attack_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_attack_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)

-- (attack2)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_attack2_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 34
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_attack2_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 34
    }
)

-- (moment_of_courage)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_moc_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 23
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_moc_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 23
    }
)

-- (overwhelming odds)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_overodds_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 34
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_overodds_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 34
    }
)

-- (duel)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_duel_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 39
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_duel_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 39
    }
)

-- (duel kill)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_duel_kill_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_duel_kill_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)

-- (flail)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_flail_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_flail_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)

-- (forcestaff friendly)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_forcestaff_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_forcestaff_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)

-- (stun)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_stun_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 49
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_stun_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 49
    }
)

-- (death)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_death_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 39
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_death_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 39
    }
)

-- (forcestaff_enemy)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_forcestaff_enemy_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_forcestaff_enemy_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 29
    }
)

-- (forcestaff_end)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_forcestaff_end_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 16
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_forcestaff_end_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 16
    }
)

-- (spawn)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_pta_spawn_layer",
        hidden = true,
        source = "@pta_cape_full_overlay",
        startframe = 0,
        endframe = 90
    }
)
SequenceFromFrameRange( 
    {
        model = model,
        name = "@lotfl_normal_spawn_layer",
        hidden = true,
        source = "@normal_cape_full_overlay",
        startframe = 0,
        endframe = 90
    }
)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------EOF---
