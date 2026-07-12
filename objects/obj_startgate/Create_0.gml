bg_surf = -1;
image_speed = 0;
depth = 20;

bg_parallax = [];

for (var i = 0; i < array_length(speed_array); i++) 
{
    var current_speed = speed_array[i];
    var sx = 0;
    var sy = 0;
    
    if (is_string(current_speed) && string_ends_with(current_speed, "y"))
    {
        var num_str = string_delete(current_speed, string_length(current_speed), 1);
        sy = real(num_str);
    }
    else
    {
        sx = real(current_speed);
    }

    var s = {
        spd_x: sx,
        spd_y: sy,
        x: 0,
        y: 0
    };
    
    array_push(bg_parallax, s);
}

#region create masking effect
var s = surface_create(sprite_get_width(door_gate), sprite_get_height(door_gate));
surface_set_target(s);
draw_clear(c_white);

gpu_set_blendmode(bm_subtract);
draw_sprite(door_gate, 1, sprite_get_xoffset(door_gate), sprite_get_yoffset(door_gate));
gpu_set_blendmode_ext(bm_src_alpha, bm_dest_alpha);
surface_reset_target();

subtract_spr = sprite_create_from_surface(s, 0, 0, sprite_get_width(door_gate), sprite_get_height(door_gate), false, false, 0, 0);
surface_free(s);
#endregion

save_data = {
    score_num: 0,
    secret_count: 0,
    rank: 0
};

save_exists = false;
toppins_to_spawn = []; // Holds data for dynamic spawning

// Live tracking variables for the dynamic spawning system
spawned_toppins = []; 
spawned_score_inst = noone; 

level_percentage_earned = 0;

ini_open(global.savestring);

if ini_section_exists(level_name)
{
    save_exists = true;
    score_num = ini_read_real(level_name, "score", 0);
    secret_count = ini_read_real(level_name, "secret_count", 0);
    
    var rank_idx = ini_read_real(level_name, "rank", 0);
    rank = rank_idx;
    
    level_percentage_earned += rank_rewards[clamp(rank_idx, 0, array_length(rank_rewards) - 1)];
    
    var toppin_arr = [
        {t_name: "shroom", idle: spr_shroomtoppin_idle, move: spr_shroomtoppin_move, taunt: spr_shroomtoppin_taunt},
        {t_name: "cheese", idle: spr_cheesetoppin_idle, move: spr_cheesetoppin_move, taunt: spr_cheesetoppin_taunt},
        {t_name: "tomato", idle: spr_tomatotoppin_idle, move: spr_tomatotoppin_move, taunt: spr_tomatotoppin_taunt},
        {t_name: "sausage", idle: spr_sausagetoppin_idle, move: spr_sausagetoppin_move, taunt: spr_sausagetoppin_taunt},
        {t_name: "pineapple", idle: spr_pineappletoppin_idle, move: spr_pineappletoppin_move, taunt: spr_pineappletoppin_taunt}
    ];
    
    for (var i = 0; i < array_length(toppin_arr); i++)
    {
        var cur_toppin = toppin_arr[i];
        var _has_toppin = ini_read_real(level_name, cur_toppin.t_name, 0);
        
        if (_has_toppin > 0)
        {
            level_percentage_earned += toppin_rewards[clamp(i, 0, array_length(toppin_rewards) - 1)];
            
            array_push(toppins_to_spawn, {
                idle: cur_toppin.idle,
                move: cur_toppin.move,
                taunt: cur_toppin.taunt
            });
        }
    }
}

ini_close();