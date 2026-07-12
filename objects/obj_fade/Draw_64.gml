if image_alpha > 0
{
	shader_set(sh_dither_fade);
	
	// Pass alpha
	var u_alpha = shader_get_uniform(sh_dither_fade, "u_alpha");
	shader_set_uniform_f(u_alpha, clamp(image_alpha, 0, 1));
	
	// Pass pixel size (e.g., 4.0 means each dither step is a 4x4 block of screen pixels)
	var u_pixel_size = shader_get_uniform(sh_dither_fade, "u_pixel_size");
	var pixel_scale = 4.0; 
	shader_set_uniform_f(u_pixel_size, pixel_scale);
	
	draw_set_color(c_black);
	draw_rectangle(0, 0, screen_w, screen_h, false);
	draw_reset_color();
	
	shader_reset();
}