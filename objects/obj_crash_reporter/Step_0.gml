if (keyboard_check_pressed(vk_space)) 
{
    global.crash_log = "No active crash log found.";
    room_goto(tower_1); 
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Update button position dynamically so it tracks the parent window
if (instance_exists(myButton)) 
{
    myButton.x = shellOriginX + width - consolePaddingH - myButton.width;
    myButton.y = shellOriginY + height - myButton.height - consolePaddingV;
}

// Window Dragging 
if (mouse_check_button_pressed(mb_left)) 
{
    // Check if clicking inside window but NOT hovering the button space
    var overButton = false;
    if (instance_exists(myButton)) {
        overButton = point_in_rectangle(mx, my, myButton.x, myButton.y, myButton.x + myButton.width, myButton.y + myButton.height);
    }
    
    if (point_in_rectangle(mx, my, shellOriginX, shellOriginY, shellOriginX + width, shellOriginY + height) && !overButton) 
    {
        isDragging = true;
        dragOffsetX = mx - shellOriginX;
        dragOffsetY = my - shellOriginY;
    }
}

if (isDragging) 
{
    if (mouse_check_button(mb_left)) 
    {
        shellOriginX = clamp(mx - dragOffsetX, 0, display_get_gui_width() - width);
        shellOriginY = clamp(my - dragOffsetY, 0, display_get_gui_height() - height);
    } 
    else 
    {
        isDragging = false;
    }
}