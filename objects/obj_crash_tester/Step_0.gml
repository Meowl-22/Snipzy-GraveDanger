if (keyboard_check_pressed(ord("C"))) 
{
    if (instance_exists(obj_player)) 
    {
        try 
        {
            with (obj_player) 
            {
                // Force the intentional crash
                var _test = intentionally_undefined_variable_for_testing + 5;
            }
        }
        catch (error) 
        {
            // Log the error details directly from the tester object's catch block
            global.crash_log = "ERROR:\n" + string(error.message) + "\n\nSTACKTRACE:\n" + string(error.stacktrace);
            
            // Safely clear the player tracking state and jump rooms
            with (obj_player) 
            {
                state = states.normal;
            }
            
            room_goto(CrashRoom); // Double-check this matches your room asset name exactly!
        }
    }
}