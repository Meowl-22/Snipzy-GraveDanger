var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var isHovered = point_in_rectangle(mx, my, x, y, x + width, y + height);

// Match the console font if available
var consoleFont = asset_get_index("fnt_console");
if (consoleFont != -1) draw_set_font(consoleFont);

if (isHovered) 
{
    // Filled hover background highlight
    draw_set_alpha(0.15);
    draw_set_color(promptColor);
    draw_roundrect_ext(x, y, x + width, y + height, 6, 6, false);
    
    // Solid border outline color
    draw_set_alpha(1.0);
    draw_set_color(promptColor);
} 
else 
{
    draw_set_alpha(1.0);
    draw_set_color(fontColorSecondary);
}

// Draw the outline bounding box
draw_roundrect_ext(x, y, x + width, y + height, 6, 6, true);

// Render centered text labels
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(isHovered ? fontColor : fontColorSecondary);
draw_text(x + (width / 2), y + (height / 2), copyButtonText);

// Reset draw states
draw_set_halign(fa_left);
draw_set_valign(fa_top);