// Draw interaction prompt above player
if (prompt_alpha > 0 && !menu_active) {
    draw_set_font(global.creditsfont);
    draw_set_alpha(prompt_alpha);
    draw_set_color(c_white);
    draw_set_align(fa_center, fa_bottom);
    
    var px = obj_player.x - camera_get_view_x(view_camera[0]);
    var py = obj_player.y - camera_get_view_y(view_camera[0]) - 80;
    
    draw_text(px, py, "PRESS UP");
    draw_set_alpha(1);
}

// Draw Menu Overlay & UI
if (ui_anim_progress > 0.01) {
    var alpha_val = ui_anim_progress;
    var pop_factor = ui_pop_scale;
    var slide_offset = (1 - ui_anim_progress) * 150;
    
    var center_x = screen_w / 2;
    var panel_y = (screen_h - 150) + slide_offset;
    
    // 1. Dark Screen Overlay
    draw_set_alpha(0.65 * alpha_val);
    draw_set_color(c_black);
    draw_rectangle(0, 0, screen_w, screen_h, false);
    
    // 2. Dynamic Card Frame Calculation
    var cur_item = clothes_arr[clothes_selected];
    var name_str = (!in_button_mode ? "<  " : "   ") + string_upper(cur_item.name) + (!in_button_mode ? "  >" : "   ");
    var desc_str = cur_item.description;
    
    draw_set_font(global.creditsfont);
    var padding = 80;
    var max_text_width = max(string_width(name_str), string_width(desc_str)) + padding;
    var min_half_width = 220;
    
    var target_half_w = max(min_half_width, max_text_width / 2);
    var box_w = target_half_w * pop_factor;
    var box_h = 130 * pop_factor;
    var corner_rad = 24 * pop_factor;
    
    // Card Box Fill & Border
    draw_set_alpha(0.9 * alpha_val);
    draw_set_color(c_black);
    draw_roundrect_ext(center_x - box_w, panel_y - box_h / 2, center_x + box_w, panel_y + box_h / 2, corner_rad, corner_rad, false);
    
    draw_set_color(!in_button_mode ? c_aqua : c_dkgray);
    draw_roundrect_ext(center_x - box_w, panel_y - box_h / 2, center_x + box_w, panel_y + box_h / 2, corner_rad, corner_rad, true);
    
    draw_set_alpha(alpha_val);
    
    // 3. Shadow & Alignment Setup
    var shadow_x = center_x;
    var shadow_y = (panel_y - box_h / 2) - 20 + preview_y_offset;
    
    // Draw Ground Shadow Ellipse
    draw_set_color(c_white);
    draw_set_alpha(0.3 * alpha_val);
    draw_ellipse(shadow_x - 32, shadow_y - 4, shadow_x + 32, shadow_y + 6, false);
    draw_set_alpha(alpha_val);
    
    // 4. Sprite Positioning & Rendering
    var spr = spr_palettedresserdebris;
    var scale_val = 2 * preview_scale * pop_factor;
    
    var draw_x = shadow_x;
    var draw_y = shadow_y - ((sprite_get_height(spr) / 2) * scale_val) + 12;

    var has_pattern = (cur_item.pattern != noone && sprite_exists(cur_item.pattern));

    // --- STEP 1: Draw Base Palette Sprite ---
    if (script_exists(asset_get_index("pal_swap_set"))) {
        pal_swap_set(pal_peppino, cur_item.pal_ix, false);
    }
    
    draw_sprite_ext(spr, 0, draw_x, draw_y, scale_val, scale_val, 0, c_white, alpha_val);
    
    if (script_exists(asset_get_index("pal_swap_reset"))) {
        pal_swap_reset();
    }
    
    // --- STEP 2: Draw Pattern Overlay with Transparency ---
    if (has_pattern && scale_val > 0.05) {
        pattern_draw(spr, 0, draw_x, draw_y, cur_item.pattern, scale_val, scale_val, 0, c_white, alpha_val);
    }

    // --- 5. CENTERED TEXT & LABELS ---
    draw_set_alpha(alpha_val);
    draw_set_color(c_white);
    draw_set_font(global.creditsfont);
    draw_set_align(fa_center, fa_middle);
    
    // Index Counter ("12 / 26")
    draw_set_color(c_gray);
    var index_str = string(clothes_selected + 1) + " / " + string(array_length(clothes_arr));
    draw_text(center_x, panel_y - (box_h / 2) + 22, index_str);
    
    // Outfit Name
    draw_set_color(!in_button_mode ? c_white : c_gray);
    draw_text(center_x, panel_y - 2, name_str);
    
    // Description
    draw_set_color(!in_button_mode ? c_white : c_dkgray);
    draw_text(center_x, panel_y + 28, desc_str);
    
    // --- 6. CENTERED ACTION BUTTONS ---
    var btn_y = panel_y + box_h / 2 + 35;
    var btn_w = 140;
    var btn_h = 40;
    var btn_gap = 20;
    
    // WEAR BUTTON
    var btn0_x = center_x - (btn_w / 2 + btn_gap / 2);
    var is_b0_sel = (in_button_mode && button_selected == 0);
    var b0_w = (btn_w / 2) * btn_scale_0;
    var b0_h = (btn_h / 2) * btn_scale_0;
    
    draw_set_color(is_b0_sel ? c_green : c_black);
    draw_set_alpha(0.9 * alpha_val);
    draw_roundrect_ext(btn0_x - b0_w, btn_y - b0_h, btn0_x + b0_w, btn_y + b0_h, 16, 16, false);
    
    draw_set_color(is_b0_sel ? c_white : c_gray);
    draw_roundrect_ext(btn0_x - b0_w, btn_y - b0_h, btn0_x + b0_w, btn_y + b0_h, 16, 16, true);
    
    draw_set_align(fa_center, fa_middle);
    draw_set_color(is_b0_sel ? c_white : c_gray);
    draw_text(btn0_x, btn_y, "WEAR");

    // EXIT BUTTON
    var btn1_x = center_x + (btn_w / 2 + btn_gap / 2);
    var is_b1_sel = (in_button_mode && button_selected == 1);
    var b1_w = (btn_w / 2) * btn_scale_1;
    var b1_h = (btn_h / 2) * btn_scale_1;
    
    draw_set_color(is_b1_sel ? c_red : c_black);
    draw_set_alpha(0.9 * alpha_val);
    draw_roundrect_ext(btn1_x - b1_w, btn_y - b1_h, btn1_x + b1_w, btn_y + b1_h, 16, 16, false);
    
    draw_set_color(is_b1_sel ? c_white : c_gray);
    draw_roundrect_ext(btn1_x - b1_w, btn_y - b1_h, btn1_x + b1_w, btn_y + b1_h, 16, 16, true);
    
    draw_set_color(is_b1_sel ? c_white : c_gray);
    draw_text(btn1_x, btn_y, "EXIT");
}