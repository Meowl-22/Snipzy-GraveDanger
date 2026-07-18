switch (state)
{
	case 0:
		// Save if the level we are leaving is the tutorial BEFORE transitioning rooms
		if (!variable_instance_exists(id, "is_tutorial"))
		{
			is_tutorial = (string_pos("tutorial", string_lower(room_get_name(room))) > 0);
			tutorial_wait = 80;        // How long the player waits at the center (80 frames ≈ 1.3 seconds)
			fade_out_started = false;  // Tracks when we start fading back to white
			fade_speed = 0.015;        // Lower = slower fade out! (0.015 is roughly 4 seconds)
			post_fade_wait = 90;       // Wait 1 second AFTER fully fading away before loading (60 frames)
		}

		if white_fade_alpha < 1
			white_fade_alpha += 0.1
		else
		{
			room_goto(rank_room)
			obj_player.spawn = "a"
			obj_player.visible = false
			obj_player.depth = prev_player_depth
			x = obj_player.x - obj_camera.campos.x
			y = obj_player.y - obj_camera.campos.y
			state++
			
			// Only trigger music and normal alarms if it's NOT the tutorial
			if (!is_tutorial)
			{
				alarm[0] = 220
				alarm[2] = 630
				scr_sound(rank_data[rank_ix].song)
			}
		}
		break;
		
	case 1:
		obj_player.sprite_index = spr_player_idle
		var tx = screen_w / 2
		var ty = screen_h / 2
		var dir = point_direction(x, y, tx, ty)
		var lx = lengthdir_x(2, dir)
		var ly = lengthdir_y(2, dir)
		x = approach(x, tx, abs(lx))
		y = approach(y, ty, abs(ly))
		
		// --- TUTORIAL SEQUENCE ---
		if (is_tutorial)
		{
			// 1. Gradually reveal the player as they move to the center
			if (!fade_out_started && white_fade_alpha > 0)
			{
				white_fade_alpha -= 0.05;
			}
			
			// 2. Once the player is centered, start the wait timer
			if (x == tx && y == ty)
			{
				if (tutorial_wait > 0)
				{
					tutorial_wait--;
				}
				else
				{
					// 3. Wait is over! Fade both the screen AND this object away slowly
					fade_out_started = true;
					if (white_fade_alpha < 1)
					{
						white_fade_alpha += fade_speed;                 // Fades screen to white slowly
						image_alpha = max(0, image_alpha - fade_speed); // Fades this object out slowly
					}
					else
					{
						// 4. Fully faded away! Now hold on white for 1 second (60 frames)
						if (post_fade_wait > 0)
						{
							post_fade_wait--;
						}
						else
						{
							// 5. Done! Go back to the hub
							room_goto(tower_1)
							reset_level()

							with obj_player
							{
								x = return_location.x
								y = return_location.y
								spawn = noone
								state = states.actor
								room_goto(return_location.room)
								reset_anim(spr_player_walkfront)
							}

							global.doorshut = true
							global.in_level = false
							instance_destroy()
						}
					}
				}
			}
		}
		break;
		
	case 2:
		if brown_alpha < 1
			brown_alpha += 0.1
		else
			state++
		break;
		
	case 3:
		for (var i = 0; i < array_length(toppins); i++) 
		{
			if toppin_ix != i
				toppins[i].image_yscale = max(toppins[i].image_yscale - 0.1, 1)
		}
		
		if (toppin_ix <= array_length(toppins) - 1)
		{
			var cur_toppin = toppins[toppin_ix]
			with cur_toppin
			{
				if y <= screen_h
				{
					with other
					{
						toppin_ix++
						if toppin_ix == array_length(toppins) - 1
							alarm[3] = 40
					}
					y = screen_h
				}
				else
				{
					if y == other.t_ystart
						scr_sound(sfx_spin)
					y -= 20
					image_yscale = 1.2
				}
			}
		}
		break;
}

if room != rank_room && sprite_index == rank_data[rank_ix].sprite
	instance_destroy()