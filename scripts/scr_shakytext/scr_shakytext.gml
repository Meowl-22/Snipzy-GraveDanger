function show_shaky_text(_text) 
{
    // Check if the text object already exists in the room
    var _inst = instance_find(obj_shakytext, 0);
    
    // If it doesn't exist, create it dynamically
    if (_inst == noone) 
    {
        _inst = instance_create_depth(0, 0, -2500, obj_shakytext);
    }
    
    // Configure the object to display your text and start the timer
    with (_inst) 
    {
        str = _text;                                  // Set the custom text
        show = true;                                  // Tell the step event to fade it in
        image_alpha = 0;                              // Reset transparency so it fades in cleanly
        alarm[0] = game_get_speed(gamespeed_fps) * 3; // Set Alarm 0 to trigger in exactly 3 seconds
    }
}