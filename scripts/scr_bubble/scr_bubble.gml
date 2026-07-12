function scr_bubble(_x, _y, _w, _h, _str_arr, _padding, _text_padding, _text_height, _bg_pos, _dir)
{
	if _y <= -_h
		exit;

	draw_set_font(global.tutorialfont)
	draw_set_align(fa_left, fa_top)
	draw_set_alpha(image_alpha)

	var _mode = 0

	for (var i = 0; i < array_length(_str_arr); i++) 
	{
		var current_line = _str_arr[i]
		var _len = string_length(current_line)
		
		// Pre-calculate precise line width for perfect centering
		var _line_width = 0
		for (var temp_j = 1; temp_j <= _len;) 
		{
			switch string_ord_at(current_line, temp_j)
			{
				case ord("["):
					var _keyword = ""
					var _j2 = temp_j + 1
					while _j2 < string_length(current_line) && string_char_at(current_line, _j2) != "]"
					{
						_keyword += string_char_at(current_line, _j2)
						_j2++
					}
					var _key_ord = -1
					switch _keyword
					{
						case "u":  _key_ord = input_get_bind(INPUTS.up); break;
						case "l":  _key_ord = input_get_bind(INPUTS.left); break;
						case "r":  _key_ord = input_get_bind(INPUTS.right); break;
						case "d":  _key_ord = input_get_bind(INPUTS.down); break;
						case "f":  _key_ord = _dir == 1 ? input_get_bind(INPUTS.right) : input_get_bind(INPUTS.left); break;
						case "b":  _key_ord = _dir == -1 ? input_get_bind(INPUTS.right) : input_get_bind(INPUTS.left); break;
						case "g":  _key_ord = input_get_bind(INPUTS.grab); break;
						case "m":  
						case "ds": _key_ord = input_get_bind(INPUTS.dash); break;
						case "j":  _key_ord = input_get_bind(INPUTS.jump); break;
						case "t":  _key_ord = input_get_bind(INPUTS.taunt); break;
						case "gp": _key_ord = input_get_bind(INPUTS.groundpound); break;
						case "sj": _key_ord = input_get_bind(INPUTS.superjump); break;
					}
					temp_j += string_length(_keyword) + 2
					
					if is_array(_key_ord)
						_line_width += sprite_get_width(spr_fontkey) * array_length(_key_ord)
					else
						_line_width += sprite_get_width(spr_fontkey)
					break;
					
				case ord("{"):
					var _keyword = ""
					var _j2 = temp_j + 1
					while _j2 < string_length(current_line) && string_char_at(current_line, _j2) != "}"
					{
						_keyword += string_char_at(current_line, _j2)
						_j2++
					}
					temp_j += string_length(_keyword) + 2
					break;
					
				default:
					var cur_char = string_char_at(current_line, temp_j)
					_line_width += string_width(cur_char)
					temp_j++
					break;
			}
		}
		
		// Set dynamic centering start point
		var xx = _x + (_w / 2) - (_line_width / 2)
		var yy = _y + _text_padding + (_text_height * i)
		
		for (var j = 1; j <= _len;) 
		{
			var _suboffset = { x: 0, y: 0 }
			
			switch _mode
			{
				case 1:
					var d = ((j % 2) == 0) ? -1 : 1;
					_suboffset.y = wave(-1, 1, 0.1, 0) * d;
					break;
				case 2:
					_suboffset.x = irandom_range(-2, 2)
					_suboffset.y = irandom_range(-2, 2)
					break;
			}
			
			var cur_char = string_char_at(current_line, j)
			var _keyword = ""
			var _j2 = j + 1
			
			switch string_ord_at(current_line, j)
			{
				case ord("["):
					while _j2 < string_length(current_line) && string_char_at(current_line, _j2) != "]"
					{
						_keyword += string_char_at(current_line, _j2)
						_j2++
					}
					var _key_ord = -1
					switch _keyword
					{
						case "u":  _key_ord = input_get_bind(INPUTS.up); break;
						case "l":  _key_ord = input_get_bind(INPUTS.left); break;
						case "r":  _key_ord = input_get_bind(INPUTS.right); break;
						case "d":  _key_ord = input_get_bind(INPUTS.down); break;
						case "f":  _key_ord = _dir == 1 ? input_get_bind(INPUTS.right) : input_get_bind(INPUTS.left); break;
						case "b":  _key_ord = _dir == -1 ? input_get_bind(INPUTS.right) : input_get_bind(INPUTS.left); break;
						case "g":  _key_ord = input_get_bind(INPUTS.grab); break;
						case "m":  
						case "ds": _key_ord = input_get_bind(INPUTS.dash); break;
						case "j":  _key_ord = input_get_bind(INPUTS.jump); break;
						case "t":  _key_ord = input_get_bind(INPUTS.taunt); break;
						case "gp": _key_ord = input_get_bind(INPUTS.groundpound); break;
						case "sj": _key_ord = input_get_bind(INPUTS.superjump); break;
					}
					j += string_length(_keyword) + 2
					
					// FIX: Resets blend color to white so keys aren't drawn black
					draw_set_color(c_white)
					
					if is_array(_key_ord)
					{
						for (var k = 0; k < array_length(_key_ord); k++) 
						{
							cc_draw_key(xx + _suboffset.x, yy + _suboffset.y, _key_ord[k])
							xx += sprite_get_width(spr_fontkey)
						}
					}
					else
					{
						cc_draw_key(xx + _suboffset.x, yy + _suboffset.y, _key_ord)
						xx += sprite_get_width(spr_fontkey)
					}
					break;
					
				case ord("{"):
					while _j2 < string_length(current_line) && string_char_at(current_line, _j2) != "}"
					{
						_keyword += string_char_at(current_line, _j2)
						_j2++
					}
					switch _keyword
					{
						case "n": _mode = 0; break;
						case "u": _mode = 1; break;
						case "s": _mode = 2; break;
					}
					j += string_length(_keyword) + 2
					break;
					
				default:
					draw_text_colour(xx + _suboffset.x, yy + _suboffset.y, cur_char, c_black, c_black, c_black, c_black, image_alpha)
					xx += string_width(cur_char)
					j++
					break;
			}
		}
	}
	draw_reset_color(1)
}