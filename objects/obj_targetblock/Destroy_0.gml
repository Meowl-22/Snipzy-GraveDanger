particle_create(x, y, particles.genericpoof)
scr_sound_3d(choose(sfx_breakblock1, sfx_breakblock2), x, y)
ds_list_add(global.ds_saveroom, id)