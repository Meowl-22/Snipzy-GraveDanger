// =========================================================================
// 1. INITIAL SETUP & PAUSE BACKGROUND
// =========================================================================
draw_set_color(c_black);

if (pause)
{
    draw_sprite(pause_image, 0, 0, 0);
}

pause_alpha = approach(pause_alpha, pause ? 1 : 0, 0.07);

// =========================================================================
// 2. ACTIVE PAUSE MENU OVERLAY
// =========================================================================
if (pause_alpha > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(pause_alpha * 0.5); 
    draw_rectangle(0, 0, screen_w, screen_h, false);
    
    draw_set_color(c_white);
    draw_set_alpha(pause_alpha);
    
    // --- Smooth Easing Calculations (Ease-Out Quintic) ---
    var ease_progress = 1 - power(1 - pause_alpha, 5);
    
    var left_sprite_w   = sprite_get_width(spr_slide_pause);
    var right_sprite_w = sprite_get_width(spr_snipzy_pause);
    
    var left_x  = lerp(-left_sprite_w, 0, ease_progress);
    var right_x = lerp(screen_w + right_sprite_w, screen_w - 150, ease_progress);
    
    var side_y  = screen_h / 2;
    var Sside_y = screen_h / 1.5;
    
    // --- Render Pause Menu Sprites with CACHED Palette ---
    // Draws the raw pattern fill layer first
    if (saved_pal_index == 12 && saved_pattern_spr != noone) 
    {
        if (spr_slide_pause != noone)  pattern_draw(spr_slide_pause, 0, left_x, side_y, saved_pattern_spr, 1, 1, 0, c_white, pause_alpha);
        if (spr_snipzy_pause != noone) pattern_draw(spr_snipzy_pause, 0, right_x, Sside_y, saved_pattern_spr, 1, 1, 0, c_white, pause_alpha);
    }
    
    // FIX: Removed the 'else' block so these lines always execute.
    // This overlays the character's outlines, face, and shading on top of the pattern.
    pal_swap_set(pal_peppino, saved_pal_index, false);
    
    draw_sprite_ext(spr_slide_pause, 0, left_x, side_y, 1, 1, 0, c_white, pause_alpha);
    draw_sprite_ext(spr_snipzy_pause, 0, right_x, Sside_y, 1, 1, 0, c_white, pause_alpha);
    
    pal_swap_reset(); 
    // -----------------------------------------------------
    
    // =====================================================================
    // OPTION MENU LOGIC LOOP (POSITIONED AT THE BOTTOM LEFT)
    // =====================================================================
    draw_set_font(global.generic_font);
    draw_set_align(fa_left, fa_top); 
    
    var s = 26;       
    var pad = 26;     
    var len = array_length(options);
    
    var sw = left_x + 30; 
    
    var total_menu_height = ((s + pad) * len) - pad;
    var sh = screen_h - total_menu_height - 30; 

    for (var i = 0; i < len; i++) 
    {
        var selected = (optionselected == i);
        var option = options[i];
        var str = $"{option.o_name}";
        var yy = sh + ((s + pad) * i);
        
        option.iconalpha = approach(option.iconalpha, selected ? 1 : 0, 0.2);
        draw_set_color(selected ? c_white : c_grey);
        
        draw_text(sw, yy, str);
        
        draw_pause_icon(option.icon_index, sw + string_width(str) + 30, yy + 12, min(pause_alpha, option.iconalpha));
    }
    
    // --- Cursor Tracking Adjustment ---
    option = options[optionselected];
    str = $"{option.o_name}";
    
    var cx = pause ? sw - 55 : -100;
    var cy = pause ? sh + ((s + pad) * optionselected) + 6 : 0;
    
    with (cursor)
    {
        draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, other.pause_alpha);
        image_index = wrap(sprite_get_number(sprite_index), image_index + image_speed);
        x = lerp(x, cx, 0.1);
        y = lerp(y, cy, 0.1);
    }
}

draw_reset_color();

// =========================================================================
// 3. SCREEN ASSETS ANIMATION LOOP (Vines drawn here first)
// =========================================================================
for (var i = 0; i < array_length(screen_assets); i++) 
{
    with (screen_assets[i])
    {
        x = lerp(x, other.pause ? endx : startx, 0.1);
        y = lerp(y, other.pause ? endy : starty, 0.1);
        draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
    }
}

// =========================================================================
// 4. LEVEL STATS OVERLAY (Drawn last, overlapping the vines, hidden in tutorial)
// =========================================================================
var _room_name = string_lower(room_get_name(room));

if (pause_alpha > 0 && global.in_level && string_pos("tutorial", _room_name) == 0)
{
    draw_set_alpha(pause_alpha);

    var tx = 100;
    var ty = 90;
    var t_ix = global.level_data.treasure;
    
    draw_sprite(spr_treasurepodium, 0, tx, ty);
    draw_sprite(spr_pause_treasuretext, t_ix, tx, ty);
    
    var sx = screen_w - 100;
    var sy = 90;
    
    draw_sprite(spr_secretportal, 0, sx, sy);
    
    draw_set_font(global.bignumber_font);
    draw_set_align(fa_right, fa_middle);
    draw_text(sx - 55, sy - 4, $"{global.level_data.secret_count}/3");
    
    draw_reset_color(); 
}