if (!info_visible) exit;

// --- UI CONFIGURATION & STYLING ---
var pad       = 12;                            // Padding from screen edges
var inner_pad = 10;                            // Space inside the boxes
var line_h    = 22;                            // Vertical spacing per line
var bg_alpha  = 0.75;                          // Sleek, dark semi-transparency

// Theme Palette (Modern Cyber/Sci-Fi)
var c_bg       = make_color_rgb(15, 18, 24);    // Deep dark navy/grey
var c_accent   = make_color_rgb(0, 191, 255);   // Electric blue accent line
var c_lbl      = make_color_rgb(140, 155, 170); // Muted grey for labels
var c_val      = c_white;                       // Bright white for values

// Dynamic Performance Coloring
var c_fps = c_lime;
if (fps < 30)       c_fps = c_red;
else if (fps < 55)  c_fps = c_orange;

// Fetch Player Sprite (Failsafe included)
var ply_sprite = "No Player";
if (instance_exists(obj_player)) {
    ply_sprite = sprite_get_name(obj_player.sprite_index);
}

// Save current draw states to safely restore them at the end
var old_font   = draw_get_font();
var old_halign = draw_get_halign();
var old_valign = draw_get_valign();

// Base Setup
draw_set_font(-4); 
draw_set_valign(fa_bottom);

// =========================================================================
// LEFT PANEL: Debug Info, Hotkeys, & Player Sprite
// =========================================================================
draw_set_halign(fa_left);

var left_w  = 280;                             // Widened slightly for sprite names
var left_h  = (line_h * 6) + (inner_pad * 2);  // Expanded to 6 lines
var lx1     = pad;
var ly2     = screen_h - pad;
var lx2     = lx1 + left_w;
var ly1     = ly2 - left_h;

// 1. Draw Background Window
draw_set_alpha(bg_alpha);
draw_set_color(c_bg);
draw_roundrect_ext(lx1, ly1, lx2, ly2, 8, 8, false);

// 2. Draw Top Accent Border Line
draw_set_alpha(0.9);
draw_set_color(c_accent);
draw_line_width(lx1 + 4, ly1, lx2 - 4, ly1, 2);

// 3. Draw Text Content (Iterating bottom to top)
draw_set_alpha(1.0);
var val_offset = 95; // X alignment for values

// Line 1: Studio / Ownership
draw_set_color(c_accent);
draw_text(lx1 + inner_pad, ly2 - inner_pad, "DJ Studio");

// Line 2: Restart Bind
draw_set_color(c_lbl); draw_text(lx1 + inner_pad, ly2 - inner_pad - line_h, "Shift + 9:");
draw_set_color(c_val); draw_text(lx1 + inner_pad + val_offset, ly2 - inner_pad - line_h, "Restart Game");

// Line 3: Reset Bind
draw_set_color(c_lbl); draw_text(lx1 + inner_pad, ly2 - inner_pad - (line_h * 2), "F1:");
draw_set_color(c_val); draw_text(lx1 + inner_pad + val_offset, ly2 - inner_pad - (line_h * 2), "Reset Position");

// Line 4: Player Sprite
draw_set_color(c_lbl); draw_text(lx1 + inner_pad, ly2 - inner_pad - (line_h * 3), "Sprite:");
draw_set_color(c_val); draw_text(lx1 + inner_pad + val_offset, ly2 - inner_pad - (line_h * 3), ply_sprite);

// Line 5: Real FPS
draw_set_color(c_lbl); draw_text(lx1 + inner_pad, ly2 - inner_pad - (line_h * 4), "FPS Real:");
draw_set_color(c_fps); draw_text(lx1 + inner_pad + val_offset, ly2 - inner_pad - (line_h * 4), string(floor(fps_real)));

// Line 6: Target FPS
draw_set_color(c_lbl); draw_text(lx1 + inner_pad, ly2 - inner_pad - (line_h * 5), "FPS:");
draw_set_color(c_fps); draw_text(lx1 + inner_pad + val_offset, ly2 - inner_pad - (line_h * 5), string(fps));


// =========================================================================
// RIGHT PANEL: Version Control
// =========================================================================
var ver_str = "Snipzy GraveDanger 1.0";
draw_set_halign(fa_right);

var rx2 = screen_w - pad;
var ry2 = screen_h - pad;
var rx1 = rx2 - string_width(ver_str) - (inner_pad * 2);
var ry1 = ry2 - string_height(ver_str) - (inner_pad * 2);

// 1. Draw Background Window
draw_set_alpha(bg_alpha);
draw_set_color(c_bg);
draw_roundrect_ext(rx1, ry1, rx2, ry2, 6, 6, false);

// 2. Draw Top Accent Border Line
draw_set_alpha(0.9);
draw_set_color(c_accent);
draw_line_width(rx1 + 4, ry1, rx2 - 4, ry1, 2);

// 3. Draw Text
draw_set_alpha(1.0);
draw_set_color(c_val);
draw_text(rx2 - inner_pad, ry2 - inner_pad, ver_str);


// =========================================================================
// SYSTEM CLEANUP
// =========================================================================
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_font(old_font);
draw_set_halign(old_halign);
draw_set_valign(old_valign);