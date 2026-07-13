// Handle timer for the "Copied!" text swap
if (copyTimer > 0) 
{
    copyTimer--;
    if (copyTimer == 0) 
    {
        copyButtonText = "Copy Log"; 
    }
}

// Mouse check on the GUI layer
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var isHovered = point_in_rectangle(mx, my, x, y, x + width, y + height);

if (isHovered && mouse_check_button_pressed(mb_left)) 
{
    // Force string clean-up to guarantee OS clipboard acceptance
    var clean_string = string_replace_all(global.crash_log, "\r", "");
    clipboard_set_text(clean_string); 
    
    copyButtonText = "Copied!";
    copyTimer = 90; // 1.5 seconds at 60 FPS
}