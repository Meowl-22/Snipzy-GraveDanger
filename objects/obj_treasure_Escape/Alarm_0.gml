obj_player.state = states.normal
	
global.combo.timer = 60

if obj_music.mu != noone
	audio_sound_gain(obj_music.mu, 1, 250)
	
if obj_music.panic_mu != noone
	audio_sound_gain(obj_music.panic_mu, 1, 250)
	
instance_destroy()