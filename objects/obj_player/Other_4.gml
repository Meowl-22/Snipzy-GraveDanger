try 
{
	if (sprite_index == spr_player_lookdoor || sprite_index == spr_player_entergate || sprite_index == spr_player_enterkeydoor)
	{
		reset_anim(spr_player_walkfront);
		image_speed = 0.35;
	}

	if (room == treasure_room)
	{
		// Added an instance_exists check here. Without this, if the door is missing, the game crashes!
		if (instance_exists(obj_returndoor)) 
		{
			x = obj_returndoor.x + 48;
			y = obj_returndoor.y + 50;
		}
		exit;
	}

	if (secret_exit && instance_exists(obj_secretportal) && !instance_exists(obj_secretportal_exit))
	{
		x = obj_secretportal.x;
		y = obj_secretportal.y;
		secret_exit = false;
	}
	else if (spawn == "LAP")
	{
		if (instance_exists(obj_lapportalexit))
		{
			with (obj_lapportalexit)
			{
				other.x = self.x;
				other.y = self.y;
				visible = true;
				alarm[0] = 20;
			}
		}
	}
	else
	{
		with (obj_doorpoint)
		{
			if (other.spawn == spawn)
			{
				other.x = x;
				other.y = y - 14;
				switch (other.door_type)
				{
					case fade_types.hallway:
						other.x += other.doorxscale * 64;
						break;
					case fade_types.v_hallway:
						other.y += other.dooryscale * 128;
						if (other.wasclimbingwall)
						{
							other.wasclimbingwall = false;
							var w = 0;
							var m = 100;
							while (w < m)
							{
								w++;
								with (other)
								{
									if (place_meeting(x + xscale, y, obj_solid))
										w = m;
									else
										x += xscale;
								}
							}
							other.state = states.climbwall;
						}
						break;
					case fade_types.door:
						if (!place_meeting(x, y, obj_exitgate))
							other.x += sprite_width / 2;
						break;
					case fade_types.box:
						with (obj_player)
						{
							if (place_meeting(x, y - 1, obj_pizzabox))
								y += 10;
							state = states.crouch;
						}
						break;
				}
			}
			else
			{
				state = states.normal;
			}
		}
	}

	// Used 'id' to ensure xstart/ystart are applied to the correct instance
	id.xstart = id.x;
	id.ystart = id.y;
		
	if (state == states.backtohub)
		y -= screen_h * 2;
}
