local minor_upgrades = {
	-- Ghostship upgrades
    {
        description = "aghsfort_kunkka_ghost_ship_mana_and_cooldown",
        ability_name = "aghsfort_kunkka_ghostship",
        special_values = {
            {
                special_value_name = "mana_cost",
                operator = MINOR_ABILITY_UPGRADE_OP_MUL,
                value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT
            }, {
                special_value_name = "cooldown",
                operator = MINOR_ABILITY_UPGRADE_OP_MUL,
                value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT
            }
        }
    }, 
    {
        description = "aghsfort_kunkka_ghost_ship_width",
        ability_name = "aghsfort_kunkka_ghostship",
        special_value_name = "ghostship_width",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 100
    }, 
    {
        description = "aghsfort_kunkka_ghost_ship_buff_duration",
        ability_name = "aghsfort_kunkka_ghostship",
        special_value_name = "buff_duration",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 2
    }, 
    {
        description = "aghsfort_kunkka_ghost_ship_stun_duration",
        ability_name = "aghsfort_kunkka_ghostship",
        special_value_name = "stun_duration",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 1 -- 0.5 was too low, 2 was too much.  1 = goldilocks?
    }, 
    {
        description = "aghsfort_kunkka_ghost_ship_absorb",
        ability_name = "aghsfort_kunkka_ghostship",
        special_value_name = "ghostship_absorb",
        operator = MINOR_ABILITY_UPGRADE_OP_MUL,
        value = 15
    }, 
	-- Torrent
    {
        description = "aghsfort_kunkka_torrent_mana_and_cooldown",
        ability_name = "aghsfort_kunkka_torrent",
        special_values = {
            {
                special_value_name = "mana_cost",
                operator = MINOR_ABILITY_UPGRADE_OP_MUL,
                value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT
            }, {
                special_value_name = "cooldown",
                operator = MINOR_ABILITY_UPGRADE_OP_MUL,
                value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT
            }
        }
    }, 
    {
        description = "aghsfort_kunkka_torrent_stun_duration",
        ability_name = "aghsfort_kunkka_torrent",
        special_value_name = "stun_duration",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 0.75 
    },
    {
        description = "aghsfort_kunkka_torrent_delay",
        ability_name = "aghsfort_kunkka_torrent",
        special_value_name = "delay",
        operator = MINOR_ABILITY_UPGRADE_OP_MUL,
        value = -25
    },
    {
        description = "aghsfort_kunkka_torrent_damage",
        ability_name = "aghsfort_kunkka_torrent",
        special_value_name = "torrent_damage",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 50  -- Bradm feedback: Move to 50 from 75
    },
	-- Tidebringer upgrades
    {
        description = "aghsfort_kunkka_tidebringer_distance",
        ability_name = "aghsfort_kunkka_tidebringer",
        special_value_name = "cleave_distance",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 100 -- Playtest feedback that 50 seemed very low, trying 100.
    }, 
    {
        description = "aghsfort_kunkka_tidebringer_damage",
        ability_name = "aghsfort_kunkka_tidebringer",
        special_value_name = "damage_bonus",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 15
    }, 
	{
        description = "aghsfort_kunkka_tidebringer_cooldown",
        ability_name = "aghsfort_kunkka_tidebringer",
        special_value_name = "cooldown",
        operator = MINOR_ABILITY_UPGRADE_OP_MUL,
        value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT
    }, -- X Marks the Spot
    {
        description = "aghsfort_kunkka_x_marks_the_spot_cooldown",
        ability_name = "aghsfort_kunkka_x_marks_the_spot",
        special_value_name = "cooldown",
        operator = MINOR_ABILITY_UPGRADE_OP_MUL,
        value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
    },
    {
        description = "aghsfort_kunkka_x_marks_the_spot_ally_duration",
        ability_name = "aghsfort_kunkka_x_marks_the_spot",
        value = 2,
        special_values = {
            {
                special_value_name = "duration",
                operator = MINOR_ABILITY_UPGRADE_OP_ADD,
                value = 2
            }, {
                special_value_name = "allied_duration",
                operator = MINOR_ABILITY_UPGRADE_OP_ADD,
                value = 2
            }
        }
    },
    {
        description = "aghsfort_kunkka_x_marks_the_spot_move_speed",
        ability_name = "aghsfort_kunkka_x_marks_the_spot",
        special_value_name = "speed_increase_pct",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 7
    },
    {
        description = "aghsfort_kunkka_x_marks_the_spot_armour",
        ability_name = "aghsfort_kunkka_x_marks_the_spot",
        special_value_name = "armour_increase",
        operator = MINOR_ABILITY_UPGRADE_OP_ADD,
        value = 3
    },
}
return minor_upgrades
