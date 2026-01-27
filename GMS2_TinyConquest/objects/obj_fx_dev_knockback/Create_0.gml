_life = 15;

//deal damage to each unit/building at the spawned location
_units_list = ds_list_create();
instance_position_list(x,y,obj_unit,_units_list,false);

for (var i = 0; i < ds_list_size(_units_list); i++)
{
    var u = _units_list[| i];

    // Friendly fire logic (unchanged)
    var valid = global._flag_friendly_fire;

    if (!valid)
    {
        if (global._dev_team_selected == "PLAYER")
            valid = (u._team == TEAM.ENEMY);
        else
            valid = (u._team == TEAM.PLAYER);
    }

    if (!valid) continue;

    // APPLY KNOCKBACK
    u._flag_knockback  = true;
    u._knockback_timer = 30;
    u._knockback_dir   = point_direction(x, y, u.x, u.y);
    u._knockback_force = 20;

    // Save current behavior
    u._saved_state  = u._state;
    u._saved_stance = u._stance;

    // Lock unit
    u._state  = UNIT_STATE.IDLE;
}

ds_list_destroy(_units_list);
