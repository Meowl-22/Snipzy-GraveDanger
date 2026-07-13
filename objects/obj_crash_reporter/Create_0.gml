if (!variable_global_exists("crash_log")) 
{
    global.crash_log = "No active crash log found.";
}

consoleFont = asset_get_index("fnt_console"); 
consoleAlpha = 0.85; 

consoleColor = #222222;                     
promptColor = make_color_rgb(142, 68, 173); 
fontColor = c_white;
fontColorSecondary = c_gray;

width = 500;  
height = 220;  
consolePaddingH = 8;
consolePaddingV = 8;

isDragging = false;
dragOffsetX = 0;
dragOffsetY = 0;

shellOriginX = round((display_get_gui_width() - width) / 2);
shellOriginY = round((display_get_gui_height() - height) / 2);

// Spawn the child copy button object
myButton = instance_create_depth(0, 0, depth - 10, obj_crash_copy_button);