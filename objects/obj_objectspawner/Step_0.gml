// Only count down if the object doesn't exist AND we aren't already animating
if (!instance_exists(current_spawned_object) && sprite_index != spr_spawnbox_open) 
{
    spawn_timer--;
    
    if (spawn_timer <= 0) 
    {
        // 1. Start the animation wind-up
        sprite_index = spr_spawnbox_open;
        image_index = 0; 
        
        // 2. NOW we spawn the object immediately as the animation begins
        current_spawned_object = instance_create_layer(x, y, "Instances", object_to_spawn);
		particle_create(x, y, particles.genericpoof)
    }
}

// Check if the opening animation has finished playing to reset the sprite
if (sprite_index == spr_spawnbox_open) 
{
    // image_number - 1 is the last frame of the animation
    if (image_index >= image_number - 1) 
    {
        // 1. Safely switch back to the idle sprite
        sprite_index = spr_spawnbox_idle;
        
        // 2. Reset the timer for the next automatic cycle
        spawn_timer = spawn_delay;
    }
}