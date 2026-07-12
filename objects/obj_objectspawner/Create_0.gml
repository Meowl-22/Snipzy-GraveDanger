// --- Spawn Settings ---
object_to_spawn = obj_pizzaboy; 
current_spawned_object = noone; 

// --- Auto-Spawn Timer Settings ---
// game_get_speed(gamespeed_fps) equals 1 second. Multiply it to get your delay.
spawn_delay = game_get_speed(gamespeed_fps) * 3; // 3 seconds
spawn_timer = spawn_delay;
