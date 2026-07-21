var touch_player = place_meeting(x, y, obj_player);

// Smooth interaction prompt fade
prompt_alpha = approach(prompt_alpha, (touch_player && !menu_active) ? 1 : 0, 0.1);

// Helper function to safely reset player input buffers & freeze movement
var suppress_player_inputs = function() {
    with (obj_player) {
        state = states.actor;
        sprite_index = spr_player_idle;
        hsp = 0;
        vsp = 0;
        movespeed = 0;
        key_grab = false;
        key_jump = false;
        key_up = false;
        key_down = false;
        key_left = false;
        key_right = false;
        if (variable_instance_exists(id, "input_buffer_grab")) input_buffer_grab = 0;
        if (variable_instance_exists(id, "input_buffer_jump")) input_buffer_jump = 0;
    }
};

// --- 1. ENTER MENU ---
if (touch_player && !menu_active) {
    if (input_check_pressed(INPUTS.up)) {
        menu_active = true;
        in_button_mode = false;
        button_selected = 0;
        refresh_selected_outfit();
        ui_pop_scale = 0.2;
        
        scr_sound_3d_pitched(sfx_dive, x, y, 0.95, 1.05);
        suppress_player_inputs();
    }
} 
// --- 2. INSIDE MENU ---
else if (menu_active) {
    suppress_player_inputs();

    // Toggle navigation mode between Carousel and Buttons
    if (input_check_pressed(INPUTS.down) && !in_button_mode) {
        in_button_mode = true;
        scr_sound_3d_pitched(sfx_enemyprojectile, x, y, 0.8, 1.0);
    } else if (input_check_pressed(INPUTS.up) && in_button_mode) {
        in_button_mode = false;
        scr_sound_3d_pitched(sfx_enemyprojectile, x, y, 1.0, 1.2);
    }

    // Carousel Navigation Mode
    if (!in_button_mode) {
        var move = input_check_pressed(INPUTS.right) - input_check_pressed(INPUTS.left);
        if (move != 0) {
            clothes_selected += move;
            
            var total_clothes = array_length(clothes_arr);
            if (clothes_selected < 0) clothes_selected = total_clothes - 1;
            if (clothes_selected >= total_clothes) clothes_selected = 0;
            
            preview_scale = 1.4;
            scr_sound_3d_pitched(sfx_enemyprojectile, x, y, 0.9, 1.1);
        }
    } 
    // Button Selection Mode
    else {
        var btn_move = input_check_pressed(INPUTS.right) - input_check_pressed(INPUTS.left);
        if (btn_move != 0) {
            button_selected = clamp(button_selected + btn_move, 0, 1);
            scr_sound_3d_pitched(sfx_enemyprojectile, x, y, 1.1, 1.3);
        }
    }

    // Confirm Key Check
    var key_confirm = input_check_pressed(INPUTS.jump) || input_check_pressed(INPUTS.grab) || (in_button_mode && input_check_pressed(INPUTS.up));
    
    if (key_confirm) {
        if (!in_button_mode) {
            in_button_mode = true;
            button_selected = 0;
        } else {
            // OPTION 1: WEAR OUTFIT
            if (button_selected == 0) {
                var palette = clothes_arr[clothes_selected].pal_ix;
                var pattern = clothes_arr[clothes_selected].pattern;
                
                with (obj_player) {
                    scr_sound_3d_pitched(sfx_clothesswitch, x, y, 0.9, 1.1);
                    
                    with (instance_create(x, y, obj_enemycorpse)) {
                        pal_select = other.pal_select;
                        pattern_spr = other.pattern_spr;
                        dopalette = true;
                        hsp = irandom_range(-5, 5);
                        vsp = irandom_range(-6, -11);
                        sprite_index = spr_palettedresserdebris;
                        depth = -400;
                    }
                    
                    pal_select = palette;
                    pattern_spr = pattern;
                    
                    ini_open(global.savestring);
                    ini_write_real("Clothes", "palette_index", pal_select);
                    ini_write_real("Clothes", "pattern_sprite", pattern_spr);
                    ini_close();
                    
                    state = states.normal;
                    sprite_index = spr_player_idle;
                    image_index = 0;
                    hsp = 0;
                    vsp = 0;
                    movespeed = 0;
                    key_grab = false;
                    key_jump = false;
                    if (variable_instance_exists(id, "input_buffer_grab")) input_buffer_grab = 0;
                    if (variable_instance_exists(id, "input_buffer_jump")) input_buffer_jump = 0;
                }
                menu_active = false;
            } 
            // OPTION 2: EXIT MENU
            else if (button_selected == 1) {
                with (obj_player) {
                    state = states.normal;
                    sprite_index = spr_player_idle;
                    image_index = 0;
                    hsp = 0;
                    vsp = 0;
                    movespeed = 0;
                    key_grab = false;
                    key_jump = false;
                    if (variable_instance_exists(id, "input_buffer_grab")) input_buffer_grab = 0;
                    if (variable_instance_exists(id, "input_buffer_jump")) input_buffer_jump = 0;
                }
                menu_active = false;
            }
        }
    }

    // QUICK EXIT / TAUNT
    if (input_check_pressed(INPUTS.taunt)) {
        with (obj_player) {
            state = states.normal;
            sprite_index = spr_player_idle;
            image_index = 0;
            hsp = 0;
            vsp = 0;
            movespeed = 0;
            key_grab = false;
            key_jump = false;
            if (variable_instance_exists(id, "input_buffer_grab")) input_buffer_grab = 0;
            if (variable_instance_exists(id, "input_buffer_jump")) input_buffer_jump = 0;
        }
        menu_active = false;
    }
}

// UI Animation Interpolation
var target_anim = menu_active ? 1 : 0;
ui_anim_progress = lerp(ui_anim_progress, target_anim, 0.18);
ui_pop_scale = lerp(ui_pop_scale, menu_active ? 1 : 0, 0.22);

btn_scale_0 = lerp(btn_scale_0, (in_button_mode && button_selected == 0) ? 1.15 : 1.0, 0.2);
btn_scale_1 = lerp(btn_scale_1, (in_button_mode && button_selected == 1) ? 1.15 : 1.0, 0.2);

preview_scale = lerp(preview_scale, 1, 0.2);
preview_y_offset = sin(current_time * 0.006) * 5;