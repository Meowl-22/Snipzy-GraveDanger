if (sprite_index == spr_spawnbox_open) 
{
    // 1. The animation just finished, so NOW we spawn the object
    current_spawned_object = instance_create_layer(x, y, "Instances", object_to_spawn);
    
    // 2. Safely switch back to the idle sprite
    sprite_index = spr_spawnbox_idle;
    
    // 3. Reset the timer for the next automatic cycle
    spawn_timer = spawn_delay;
}