talking = (state != 0)
sprite_index = talking ? spr_pizzagranny_talk : spr_pizzagranny_sleep

switch (state)
{
	case 0:
		// Safe fallback layout math for when bubble moves offscreen
		var _calculated_h = text_height + padding + (array_length(str_arr) * text_height)
		internal_y = max(internal_y - 5, -_calculated_h - padding);
		
		if (obj_player.state != states.backtohub && place_meeting(x, y, obj_player))
		{
			state = 1
			vsp = 0
			
			// Choose and play one of the three tutorial man sound effects
			var _sound = choose(sfx_tutrman1, sfx_tutrman2, sfx_tutrman3);
			audio_play_sound(_sound, 1, false);
		}
		break;
		
	case 1:
		internal_y += vsp;
		if vsp < 20
			vsp += 0.5
		if internal_y > padding
			state = 2
		break;
		
	case 2:
		internal_y = max(internal_y - 2, padding)
		if !place_meeting(x, y, obj_player)
			state = 0
		break;
}

bg_pos.x++
bg_pos.y++
wave_timer += 20
if (global.panic.active) 
{
text = "...well i did not expect that...";
}