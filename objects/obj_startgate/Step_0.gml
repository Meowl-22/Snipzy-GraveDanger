if surface_exists(bg_surf)
{
    for (var i = 0; i < array_length(bg_parallax); i++) 
    {
        with bg_parallax[i] 
        {
            x += spd_x;
            y += spd_y;
        }
    }
}

#region Show/Hide Management

// ==========================================
// 1. TOPPINS: Only cares if ShowStuff is ON
// ==========================================
if (ShowStuff)
{
    // If they aren't spawned yet, create them exactly once
    if (array_length(spawned_toppins) == 0 && save_exists)
    {
        for (var i = 0; i < array_length(toppins_to_spawn); i++)
        {
            var t_data = toppins_to_spawn[i];
            var inst_toppin = instance_create(x, y - 46, obj_gatetoppin);
            with (inst_toppin)
            {
                sprs = {
                    idle: t_data.idle,
                    move: t_data.move,
                    taunt: t_data.taunt
                };
            }
            array_push(spawned_toppins, inst_toppin);
        }
    }
}
else
{
    // If ShowStuff turns OFF, destroy the Toppins
    if (array_length(spawned_toppins) > 0)
    {
        for (var i = 0; i < array_length(spawned_toppins); i++)
        {
            if (instance_exists(spawned_toppins[i]))
            {
                instance_destroy(spawned_toppins[i]);
            }
        }
        array_clear(spawned_toppins); // Clear the tracking list
    }
}

// ==========================================
// 2. SCORE & RANK: Spawns when near, STAYS until ShowStuff is OFF
// ==========================================
if (ShowStuff)
{
    // Only spawn the score if the player approaches the door AND it doesn't exist yet
    if (place_meeting(x, y, obj_player))
    {
        if (spawned_score_inst == noone && save_exists)
        {
            spawned_score_inst = instance_create(x, bbox_top, obj_gatescore);
            with (spawned_score_inst)
            {
                number = other.score_num;
                rank_ix = other.rank;
            }
        }
    }
}
else
{
    // If ShowStuff is turned OFF globally/externally, destroy the Score
    if (spawned_score_inst != noone)
    {
        if (instance_exists(spawned_score_inst))
        {
            instance_destroy(spawned_score_inst);
        }
        spawned_score_inst = noone; // Reset the tracker
    }
}
#endregion

// Player entering gate interaction
if (place_meeting(x, y, obj_player) && scr_can_enter_door(obj_player.state) && input_direction_check(INPUTS.up) && obj_player.grounded)
{
    var custom_fade_time = 400; 
    
    with obj_player
    {
        reset_anim(spr_player_entergate);
        state = states.actor;
        hsp = 0;
        movespeed = 0;
        image_speed = 0.35;
        spawn = noone;
        return_location = {
            x: x,
            y: y,
            room: room
        };
        
        var total_steps = image_number / image_speed;
        custom_fade_time = total_steps * (1000 / game_get_speed(gamespeed_fps));
    }
    
    if (instance_exists(obj_music) && obj_music.mu != noone)
    {
        var is_same_music = (obj_music.mu == title_data[0]) || (audio_is_playing(obj_music.mu) && audio_sound_get_asset(obj_music.mu) == title_data[0]);
        
        if (!is_same_music)
        {
            audio_sound_gain(obj_music.mu, 0, custom_fade_time);
        }
    }
}

var flick = false;
with instance_place(x, y, obj_player)
{
    if (sprite_index == spr_player_entergate && !obj_fade.fade && image_speed > 0 && anim_ended())
    {
        flick = true;
        image_speed = 0;
    }
}

if flick
{
    if (instance_exists(obj_music) && obj_music.mu != noone)
    {
        var is_same_music = (obj_music.mu == title_data[0]) || (audio_is_playing(obj_music.mu) && audio_sound_get_asset(obj_music.mu) == title_data[0]);
        
        if (!is_same_music)
        {
            audio_stop_sound(obj_music.mu);
            audio_sound_gain(obj_music.mu, 1, 0); 
        }
    }
    
    var d = { 
        music: title_data[0],
        card_index: title_data[1],
        title_index: title_data[2]
    };
    
    with instance_create(0, 0, obj_titlecard)
    {
        music = d.music;
        card_index = d.card_index;
        title_index = d.title_index;
        t_room = other.t_room;
        t_door = other.t_door;
    }
    
    global.start_room = t_room;
    global.level_data.level_name = self.level_name;
    
    obj_score.prev_rank_ix = 0;
    
    set_rank_milestones(rank_scores[0], rank_scores[1], rank_scores[2], rank_scores[3]);
}