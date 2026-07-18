var playerid = obj_player

if (!instance_exists(playerid))
    exit
    
var _move = true

with obj_player
{
    if (state == states.actor)
        _move = false
}

if !instance_exists(obj_treasure)
{
    if image_alpha >= 1
    {
        if (!obj_fade.fade && obj_player.state != states.actor)
        {
            if _move
            {
                // --- SLINGSHOT / SPEED BOOST LOGIC ---
                var dist = point_distance(x, y, playerid.x, playerid.y);
                
                var normal_speed = 3;     
                var max_boost_speed = 25; // Super fast when out of range
                var sling_speed = 18;     // Sudden burst of speed when very close
                var threshold_dist = 600; // Distance considered "out of frame"
                var close_dist = 120;     // Distance to trigger the final "sling"
                
                if (dist > threshold_dist)
                {
                    // Extremely fast when trying to get back in frame
                    maxspeed = lerp(maxspeed, max_boost_speed, 0.1);
                }
                else if (dist < close_dist)
                {
                    // Lunge/Sling directly at the player when very close
                    maxspeed = lerp(maxspeed, sling_speed, 0.25);
                }
                else
                {
                    // Smoothly slow down to normal speed when in the middle range
                    maxspeed = lerp(maxspeed, normal_speed, 0.1);
                }

                // --- MOVEMENT ---
                var dir = point_direction(x, y, playerid.x, playerid.y)
                x += lengthdir_x(maxspeed, dir)
                y += lengthdir_y(maxspeed, dir)
                
                // --- FACE AWAY FROM PLAYER ---
                if (playerid.x > x)
                {
                    image_xscale = -1; 
                }
                else
                {
                    image_xscale = 1;
                }
            }
        }
    }
    else
        image_alpha += 0.01
}
else
{
    x = -200
    y = -200
}

if !_move
    image_alpha = approach(image_alpha, 0, 0.1)

if (_move && place_meeting(x, y, playerid) && playerid.state != states.actor && !obj_fade.fade && !instance_exists(obj_rank) && image_alpha >= 1)
{
    with playerid
    {
        door_type = fade_types.generic
        hsp = 0
        vsp = 0
        movespeed = 0
        spawn = "a"
        state = states.actor
        sprite_index = spr_player_timesup
        image_index = 0
        global.secret = false
        if obj_music.mu != noone
            audio_stop_sound(obj_music.mu)
        if obj_music.secret_mu != noone
            audio_stop_sound(obj_music.secret_mu)
        scr_sound(sfx_explosion)
        scr_sound(sfx_groundpound)
        scr_sound(sfx_timesup)
        scr_sound(mu_timesup)
    }
    room_goto(rm_timesup)
    instance_destroy()
}