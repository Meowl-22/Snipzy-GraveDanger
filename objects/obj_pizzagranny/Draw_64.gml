// 1. DYNAMIC BUBBLE HEIGHT RESET
var base_h = text_height + padding
var extra_h = 0

// 2. TAG-AWARE WORD WRAPPER (Pushes overflow words to new lines)
draw_set_font(global.tutorialfont)
str_arr = []

var text_len = string_length(text)
var i = 1
var current_line = ""
var current_word = ""
var line_w = 0
var word_w = 0
var max_w = (screen_w - (padding * 2)) - (text_padding * 2)

while (i <= text_len)
{
	var char = string_char_at(text, i)
	
	if (char == "[" || char == "{")
	{
		if (current_word != "") {
			if (line_w + word_w > max_w && current_line != "") {
				array_push(str_arr, current_line)
				extra_h += text_height
				current_line = ""
				line_w = 0
			}
			current_line += current_word
			line_w += word_w
			current_word = ""
			word_w = 0
		}
		
		var close_char = (char == "[") ? "]" : "}"
		var tag = char
		var j2 = i + 1
		while (j2 <= text_len && string_char_at(text, j2) != close_char) {
			tag += string_char_at(text, j2)
			j2++
		}
		if (j2 <= text_len) tag += close_char
		var advance = string_length(tag)
		
		var tag_w = 0
		if (char == "[") {
			var _keyword = string_copy(tag, 2, string_length(tag) - 2)
			var _key_ord = -1
			switch _keyword {
				case "u":  _key_ord = input_get_bind(INPUTS.up); break;
				case "l":  _key_ord = input_get_bind(INPUTS.left); break;
				case "r":  _key_ord = input_get_bind(INPUTS.right); break;
				case "d":  _key_ord = input_get_bind(INPUTS.down); break;
				case "f":  _key_ord = dir == 1 ? input_get_bind(INPUTS.right) : input_get_bind(INPUTS.left); break;
				case "b":  _key_ord = dir == -1 ? input_get_bind(INPUTS.right) : input_get_bind(INPUTS.left); break;
				case "g":  _key_ord = input_get_bind(INPUTS.grab); break;
				case "m":  
				case "ds": _key_ord = input_get_bind(INPUTS.dash); break;
				case "j":  _key_ord = input_get_bind(INPUTS.jump); break;
				case "t":  _key_ord = input_get_bind(INPUTS.taunt); break;
				case "gp": _key_ord = input_get_bind(INPUTS.groundpound); break;
				case "sj": _key_ord = input_get_bind(INPUTS.superjump); break;
			}
			if is_array(_key_ord)
				tag_w = sprite_get_width(spr_fontkey) * array_length(_key_ord)
			else
				tag_w = sprite_get_width(spr_fontkey)
		}
		
		if (line_w + tag_w > max_w && current_line != "") {
			array_push(str_arr, current_line)
			extra_h += text_height
			current_line = ""
			line_w = 0
		}
		current_line += tag
		line_w += tag_w
		i += advance
	}
	else if (char == " ")
	{
		if (current_word != "") {
			if (line_w + word_w > max_w && current_line != "") {
				array_push(str_arr, current_line)
				extra_h += text_height
				current_line = ""
				line_w = 0
			}
			current_line += current_word
			line_w += word_w
			current_word = ""
			word_w = 0
		}
		
		var space_w = string_width(" ")
		if (line_w + space_w > max_w && current_line != "") {
			array_push(str_arr, current_line)
			extra_h += text_height
			current_line = ""
			line_w = 0
		} else {
			current_line += " "
			line_w += space_w
		}
		i++
	}
	else
	{
		current_word += char
		word_w += string_width(char)
		i++
	}
}

if (current_word != "") {
	if (line_w + word_w > max_w && current_line != "") {
		array_push(str_arr, current_line)
		extra_h += text_height
		current_line = ""
		line_w = 0
	}
	current_line += current_word
}
if (current_line != "") {
	array_push(str_arr, current_line)
}

// Update runtime bubble sizing tracking dimensions
bubble = {
	x: padding + wave(-5, 5, 2, 10, wave_timer),
	y: internal_y + wave(-1, 1, 4, 0, wave_timer),
	w: screen_w - (padding * 2),
	h: base_h + extra_h
}

// 3. RENDER BACKGROUND INFRASTRUCTURE
draw_sprite(spr_tutorialbubble_rope, 0, bubble.x + padding, bubble.y)
draw_sprite(spr_tutorialbubble_rope, 0, bubble.x + bubble.w - padding, bubble.y)

// FIX: Surface cleared with transparency so background tiles show through
if (!surface_exists(bubble_surf)) {
	bubble_surf = surface_create(bubble.w, bubble.h)
}

surface_set_target(bubble_surf)
draw_clear_alpha(c_black, 0) 
draw_sprite_tiled(spr_tutorialbubble_bg, 0, bg_pos.x, bg_pos.y)
	
gpu_set_blendmode(bm_subtract)
draw_sprite_stretched(spr_tutorialbubble, 1, 0, 0, bubble.w, bubble.h)
gpu_set_blendmode_normal_fixed() 
surface_reset_target()
	
draw_surface(bubble_surf, bubble.x, bubble.y)
draw_sprite_stretched(spr_tutorialbubble, 0, bubble.x, bubble.y, bubble.w, bubble.h)

// 4. EXECUTE SCRIPT RENDERING
scr_bubble(bubble.x, bubble.y, bubble.w, bubble.h, str_arr, padding, text_padding, text_height, bg_pos, dir);