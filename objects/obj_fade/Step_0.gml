// --- STEP EVENT ---

// 1. Move player if fade starts during specific door types
if fade && (obj_player.door_type == fade_types.hallway || obj_player.door_type == fade_types.v_hallway)
{
	obj_player.x = pos.x;
	obj_player.y = pos.y;
}

// 2. Handle the alpha progression
image_alpha = approach(image_alpha, fade ? fade + 0.2 : fade, 0.1);

// 3. Room transition trigger once fully blacked out
if image_alpha == 1.2
{
	room_goto(target_room);
	fade = false; // Begin fading back in inside the new room
}