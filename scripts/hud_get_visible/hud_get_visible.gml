function hud_get_visible(hideforboss = true)
{
    var room_name = room_get_name(room);
    
    return !string_starts_with(room_name, "Tutorial") &&
           !string_starts_with(room_name, "tower") &&
		   !string_starts_with(room_name, "CrashRoom") &&
           !(global.boss_room && hideforboss) &&
           room != rank_room &&
           room != rm_timesup &&
           room != mainmenu &&
           global.option_showhud;
}