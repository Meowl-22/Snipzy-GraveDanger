// Place strictly inside obj_player -> Draw Event:

var xx = x;
var yy = y;

if (visual_size == 0) exit;

if (hitstun > 0)
{
    var range = 5;
    xx += irandom_range(-range, range);
    yy += irandom_range(-range, range);
}

// FIX: Always default to pure white (or the original image_blend) so it doesn't get stuck
var final_blend = c_white; 

if (sprite_index == spr_player_walkfront)
{
    // Temporarily calculates the fade effect only for this specific sprite frame layout
    final_blend = make_color_hsv(0, 0, (1 - ((image_number - image_index) / image_number)) * 255);
}
else
{
    // Reset image_blend back to normal so other states don't inherit the grayscale value
    image_blend = c_white;
    final_blend = image_blend;
}

// 1. Draw Custom Pattern Sheet if Index is 12
if (pal_select == 12 && pattern_spr != noone)
{
    // CHANGED: Uses final_blend instead of image_blend
    pattern_draw(sprite_index, image_index, xx, yy, pattern_spr, xscale * visual_size, image_yscale * visual_size, image_angle, final_blend, image_alpha);
}

// 2. Execute Palette Swapping Pipeline
pal_swap_set(pal_peppino, pal_select, false);
// CHANGED: Uses final_blend instead of image_blend
draw_sprite_ext(sprite_index, image_index, xx, yy, xscale * visual_size, image_yscale * visual_size, image_angle, final_blend, image_alpha);
pal_swap_reset();

// 3. Draw Flash Overlay Over the Palette
if (flash > 0)
{
    shader_set(shd_flash);
    // CHANGED: Uses final_blend instead of image_blend
    draw_sprite_ext(sprite_index, image_index, xx, yy, xscale * visual_size, image_yscale * visual_size, image_angle, final_blend, image_alpha);
    shader_reset();
}

// 4. Render UI Elements Linked to Player Spatial Location
with (uparrow)
{
	// Safely initialize a timer variable if it doesn't already exist on the struct
	if (!variable_struct_exists(self, "timer")) timer = 0;
	
	// Progress the squish timer continuously
	timer += 0.05; // Change this value to adjust the speed (e.g., 0.03 for slower, 0.08 for faster)
	
	// Generate matching squish and squash scales using a sine wave
	var _xs = 1 + sin(timer) * 0.15; // 0.15 controls the intensity/depth of the stretch
	var _ys = 1 - sin(timer) * 0.15; // Inverse sine ensures it squashes vertically when stretching horizontally
	
    if (visible)
    {
		// Draw the arrow utilizing custom image scales
        draw_sprite_ext(sprite_index, image_index, other.x, other.y + yoffset, _xs, _ys, 0, c_white, 1);
    }
    image_index += image_speed;
}